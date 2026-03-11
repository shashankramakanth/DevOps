resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name = "${var.aws_project}-${var.aws_environment}-vpc"
    }
}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "${var.aws_project}-${var.aws_environment}-igw"
    }
}


resource "aws_subnet" "this" {

    for_each = var.subnets

    vpc_id = aws_vpc.this.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    map_public_ip_on_launch = each.value.map_public_ip_on_launch

    tags = {
        Name = "${var.aws_project}-${var.aws_environment}-subnet-${each.key}"
    }
}

#EIP for NAT Gateway

resource "aws_eip" "nat" {
    count = var.enable_nat_gateway ? 1 : 0
    domain = "vpc"

    tags = {
        Name = "${var.aws_project}-${var.aws_environment}-nat-eip"
    }
}

#NAT Gateway

resource "aws_nat_gateway" "this" {
    count = var.enable_nat_gateway ? 1 : 0
    allocation_id = aws_eip.nat[0].id
    subnet_id = [for k, v in "aws_subnet.this" : v.id if v.map_public_ip_on_launch == "true"][0]

    tags = {
        Name = "${var.aws_project}-${var.aws_environment}-nat-gateway"
    }

    depends_on = [aws_internet_gateway.this]
}

#public route table

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.this.id
    }

    tags = {
        Name = "${var.aws_project}-${var.aws_environment}-public-route-table"
    }
}

#private route table

resource "aws_route_table" "private" {
    count = var.enable_nat_gateway ? 1 : 0
    vpc_id = aws_vpc.this.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.this[0].id
    }

    tags = {
        Name = "${var.aws_project}-${var.aws_environment}-private-route-table"
    }
}

#route table association

resource "aws_route_table_association" "public" {
    for_each = [for k, v in "aws_subnet.this" : v.id if v.map_public_ip_on_launch == "true"][0]
    route_table_id = aws_route_table.public.id
    subnet_id = aws_subnet.this[each.key].id
}

resource "aws_route_table_association" "private" {
    for_each = var.enable_nat_gateway ? {for k, v in "aws_subnet.this" : v.id if v.map_public_ip_on_launch == "false"} : {}
    route_table_id = aws_route_table.private[0].id
    subnet_id = aws_subnet.this[each.key].id
}