FFD.Locations = {
    ["burgershot"] = {
        max_stocks = 15,
        bag_model = `prop_food_bs_bag_01`,
        cooldown = 30, -- in secs
        blip = {
            enabled = true,
            coords  = vec3(-1197.93, -890.53, 13.89),
            label = "Burgershot Delivery Job",
            sprite = 536,
            scale = 0.2,
            colour = 1,
        },
        delivery = {
            item = "delivery_food",
            money_type = "cash",
            deposit = {
                enabled = true,
                amount = 25
            },
            reward = {
                enabled = true,
                min = 100,
                max = 150
            }
        },
        restock = {
            job = true,
            item = "burger",
            reward = {
                enabled = true,
                type = "cash",
                min = 200,
                max = 250
            }
        },
        positions = {
            start_delivery = {
                type = "target",
                job = {
                    required = false,
                    job_name = nil,
                },
                coords = vec4(-1196.2953, -891.9724, 12.9742, 38.5648),
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
                    job_name = "burger_shot",
                },
                coords = vec4(-1202.5074, -899.5958, 12.9742, 310.2796),
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