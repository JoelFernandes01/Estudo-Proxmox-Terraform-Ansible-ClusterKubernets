#variable "vm_tags_control" {
#  default = ["control-plane", "production", "ubuntu", "server", "kubernetes"]
#}
#variable "vm_tags_worker" {
#  default = ["control-worker", "production", "ubuntu", "server", "kubernetes"]
#}
variable "ssh_user" {
    default = "ubuntu"
}

variable "ssh_password" {
    default = "connect"
}

variable "pm_user" {
    # Remember to include realm in username - user@realm
    default = "root@pam"
}

variable "pm_password" {
    default = "connect@2025"
}

variable "pm_api_token_id" {
    # api token id is in the form of: <username>@pam!<tokenId>
    default = "terraform-prov@pve!terraform-token"
} 

variable "pm_api_token_secret" {
    # this is the full secret wrapped in quotes:
    default = "aefc5746-b35a-4df0-bac1-64492ac81bfb"
}

variable "pm_api_url" {
    # proxmox cluster api url
    default = "https://proxmox-01.connect.local:8006/api2/json"
}

variable "ssh_key" {
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCt4kFTou6QMv2PmWBKfKKxJJjCWVZauAAbqVILKkTRqtR74Bx2kSUcpXGAz3iY4xPdw8BlLWWkGYeEQdewxNfZdbK3UPOAOmmbP6zx8RFMLa8oyjjZ7qOtzCPTA95j0cEAZhiCvkak+uhlcZAff4wYefCPErSIbrt6MC80qq8xiGah6CBYGTqV1CXewYYerK+cC5tAjFt3RV1gHEdkKZZ9TNA/RH4ra9rx5nXCLDqsXPjbgYBnAYvm7X1z6f03/JNqjVuBQKaKE/XzkF25cp708SbHQnrH8MpjRsz3N1bxBfTZb4sLqGqI2L7MNac4JlxV1kYmv5Dm9jy3ao1slJJRGELFwuXiGTYOyGp/0lHZ5hWhqzOyppamrebeRJsbQSuxfZEv7F8TjfsLNreahrLCyL0aJih+oYzJ8Qm70TuXAdG2StzztjGQYnOP2dDEjvCGqgIj2cGXGJEmJSFyGrfT7BWJKSls0lrNSqBmorbeSfdilO+9CJ6hO3a2glcgS7U= joel_fernandes@hotmail.com"
}
