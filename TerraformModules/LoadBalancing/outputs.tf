output "lb_id" {
  value = aws_lb.front_lb.id
}

output "lb_arn" {
  value = aws_lb.front_lb.arn
}

output "TG_Front_Group" {
  value = aws_lb_target_group.front-end-machines.id
}

output "TG_Back_Group" {
  value = aws_lb_target_group.back-end-machines.id
}

output "TG_Front_Group_ARN" {
  value = aws_lb_target_group.front-end-machines.arn
}

output "TG_Back_Group_ARN" {
  value = aws_lb_target_group.back-end-machines.arn
}
