resource "aws_vpc" "gc" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
     "Name", "terraform-eks-gc-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "gc" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.gc.id}"

  tags = "${
    map(
     "Name", "terraform-eks-gc-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "gc" {
  vpc_id = "${aws_vpc.gc.id}"

  tags  = {
    Name = "terraform-eks-gc"
  }
}

resource "aws_route_table" "gc" {
  vpc_id = "${aws_vpc.gc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gc.id}"
  }
}

resource "aws_route_table_association" "gc" {
  count = 2

  subnet_id      = "${aws_subnet.gc.*.id[count.index]}"
  route_table_id = "${aws_route_table.gc.id}"
}
