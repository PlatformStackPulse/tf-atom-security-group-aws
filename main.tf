resource "aws_security_group" "this" {
  count = module.this.enabled ? 1 : 0

  name        = module.this.id
  description = coalesce(var.description, module.this.id)
  vpc_id      = var.vpc_id

  tags = merge(module.this.tags, { Name = module.this.id })
}
