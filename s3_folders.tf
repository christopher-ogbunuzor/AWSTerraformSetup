# I want to create multiple folders inside s3 bucket using terraform

variable "default_s3_content" {
   description = "The default content of the s3 bucket upon creation of the bucket"
   type = set(string)
   default = ["folder1", "folder2", "folder3", "folder4", "folder5"]
}
resource "aws_s3_object" "default_s3_content" {
    for_each = var.default_s3_content
    bucket = aws_s3_bucket.mys3statebucket.id
    key = "${each.value}/"  # trailing slash is required, else it create empty file
}

# ===========================================
variable "myfolders" {
   description = "The default folders containing the subfolders below"
   default = ["folder6", "folder7", "folder8", "folder9", "folder10"]
}
variable "subfolders" {
   description = "The default subfolders in each of the more folders 6 to 10"
   default = ["subfolder1", "subfolder2", "subfolder3", "subfolder4", "subfolder5"]
}
resource "aws_s3_object" "morefolder" {
    for_each = toset(var.myfolders) # for each needs: convert list to set
    bucket = aws_s3_bucket.mys3statebucket.id
    key = "${each.value}/"  # trailing slash is required, else it create empty file
}
# resource "aws_s3_object" "moresubfolder" {
#     for_each = var.myfolders
#     bucket = aws_s3_bucket.mys3statebucket.id
#     key = "${each.value}/"  # trailing slash is required, else it create empty file
# }

# Create folders in the S3 bucket
# resource "aws_s3_bucket_object" "myfolders" {
#   count         = length(var.myfolders)
#   bucket        = aws_s3_bucket.mys3statebucket.id
#   key           = "${var.myfolders[count.index]}/"
#   source        = "/dev/null" # Creating empty objects to represent folders
#   content_type  = "application/x-directory"
# }

# Create subfolders inside each folder
resource "aws_s3_bucket_object" "moresubfolders" {
  count         = length(var.myfolders) * length(var.subfolders)
  bucket        = aws_s3_bucket.mys3statebucket.id
  key           = "${var.myfolders[floor(count.index / length(var.subfolders))]}/${var.subfolders[count.index % length(var.subfolders)]}/"
    # key = "${element(var.myfolders, count.index / length(var.subfolders))}/${element(var.subfolders, count.index % length(var.subfolders))}/"
  source        = "/dev/null" # Creating empty objects to represent folders
  content_type  = "application/x-directory"
 }
