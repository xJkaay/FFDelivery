KloudDev.Locations = {
    ["burgershot"] = {
        max_stocks = 15,
        bag_model = `prop_food_bs_bag_01`,
        cooldown = 30, -- in secs
        blip = {
            enabled = true,
            coords  = vec3(-1197.93, -890.53, 13.89),
            label = "Burgershot",
            sprite = 536,
            scale = 0.9,
            colour = 1,
        },
        delivery = {
            item = "delivery_food",
            money_type = "cash",
            deposit = {
                enabled = true,
                amount = 200
            },
            reward = {
                enabled = true,
                min = 300,
                max = 350
            }
        },
        restock = {
            job = true,
            item = "burger",
            reward = {
                enabled = true,
                type = "cash",
                min = 100,
                max = 200
            }
        },
        positions = {
            start_delivery = {
                type = "target",
                job = {
                    required = false,
                    job_name = nil,
                },
                coords = vec4(-1198.74, -891.4, 12.89, 344.91),
                ped = {
                    enabled = true,
                    model = "csb_burgerdrug",
                    animation = {
                        dict = nil,
                        clip = nil,
                    }
                }
            },
            stock_zone = {
                type = "target",
                job = {
                    required = true,
                    job_name = "burgershot",
                },
                coords = vec4(-1198.81, -893.19, 12.89, 167.87),
                ped = {
                    enabled = true,
                    model = "csb_burgerdrug",
                    animation = {
                        dict = nil,
                        clip = nil,
                    }
                }
            },
        },
    }
}