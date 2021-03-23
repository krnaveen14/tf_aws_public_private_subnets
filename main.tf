resource "aws_internet_gateway" "mod" {
  vpc_id = "${var.vpc_id}"
  tags = {
    Name = "${var.name}"
    project = "${var.project}"
    tf-module = "tf_vpc_core"
    env = "${var.env}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"
  tags = {
    Name = "${var.name}-public"
    project = "${var.project}"
    tf-module = "tf_vpc_core"
    env = "${var.env}"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.mod.id}"
}

resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"
  count = "${length(compact(split(",", var.private_subnets)))}"
  tags = {
    Name = "${var.name}-private"
    project = "${var.project}"
    tf-module = "tf_vpc_core"
    env = "${var.env}"
  }
}

resource "aws_subnet" "private" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${element(split(",", var.private_subnets), count.index)}"
  availability_zone = "${element(split(",", var.availability_zones), count.index)}"
  count = "${length(compact(split(",", var.private_subnets)))}"
  tags = {
    Name = "${var.name}-private"
    project = "${var.project}"
    tf-module = "tf_vpc_core"
    env = "${var.env}"
  }
}

resource "aws_subnet" "public" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${element(split(",", var.public_subnets), count.index)}"
  availability_zone = "${element(split(",", var.availability_zones), count.index)}"
  count = "${length(compact(split(",", var.public_subnets)))}"
  tags = {
    Name = "${var.name}-public"
    project = "${var.project}"
    tf-module = "tf_vpc_core"
    env = "${var.env}"
  }

  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "private" {
  count = "${length(compact(split(",", var.private_subnets)))}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "public" {
  count = "${length(compact(split(",", var.public_subnets)))}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
