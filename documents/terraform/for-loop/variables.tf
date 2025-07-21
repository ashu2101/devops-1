variable "bucket_names" {
  type    = list(string)
  default = ["tf-create-buckket-1", "tf-create-buckket-2", "tf-create-buckket-3"]
}

# each.key / each.value = "tf-create-buckket-1"
# each.key / each.value = "tf-create-buckket-2"
# each.key / each.value = "tf-create-buckket-3"


# variable "bucket_vs_region" {
#   type    = map(string)
#   default = { "tf-create-buckket-1" : "us-east-1", "tf-create-buckket-2" : "ap-south-1", "tf-create-buckket-3" : "us-west-2" }
# }
# # each.key = "tf-create-buckket-1" and each.value = "us-east-1"
# # each.key = "tf-create-buckket-2" and each.value = "ap-south-1"
# # each.key = "tf-create-buckket-3" and each.value = "us-west-2"



# create 3 byuckets in aws using terraform. All 3 buckets should have same coinfiguration.

# [] - [1,2,3,4] for_each : value OR key

# for_each = [for bucket_name in var.bucket_names : bucket_name]
