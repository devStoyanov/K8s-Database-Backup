variable "prefix" {
  type        = string
  description = "A prefix used for all resources in this example"
}

variable "location" {
  type        = string
  description = "The Azure Region in which all resources in this example should be provisioned"
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool"
}