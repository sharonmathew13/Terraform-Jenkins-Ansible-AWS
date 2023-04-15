module "network" {
  source = "./NETWORK"
}

module "compute" {
  source          = "./COMPUTE"
  web-sg          = module.network.web-sg
}
