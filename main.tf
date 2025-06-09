resource "local_file" "my_text_file" {  
  filename = "pets.txt"
  content = "I love my dog"
}

output "local_file_path" {
  value = local_file.my_text_file.filename
  description = "The path to the local file"
}