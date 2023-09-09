# Kloud Fast Food Delivery

A highly optimized and highly configurable script made for FiveM by Kloud Development.

# Preview
* https://youtu.be/HJ1yKEIznsc

# Features

* Highly Configurable
* Highly Optimized (0.00ms Idle ~ 0.06ms Job Active)
* Usage of Targeting Script for more immersive experience
* Prop Usage for more immersive experience
* Smooth Animations

# Dependencies

**Required**

* [ox_lib](https://github.com/overextended/ox_lib)
* [oxmysql](https://github.com/overextended/oxmysql)

**Target**

- [qb-target](https://github.com/qbcore-framework/qb-target) 
- [ox_target](https://github.com/overextended/ox_target)

**Inventory**

- [qb-inventory](https://github.com/qbcore-framework/qb-inventory)
- [lj-inventory](https://github.com/loljoshie/lj-inventory)
- [ps-inventoy](https://github.com/Project-Sloth/ps-inventory)
- [ox_inventory](https://overextended.dev/ox_inventory) 
- qs-inventory (experimental)

# Installation
### For ox_inventory
* ox_inventory/data/items.lua
 ```lua
['delivery_food'] = {
	label = 'Delivery Food',
	weight = 300,
	stack = false,
	close = false,
	description = 'Grab?'
},

['burger'] = {
	label = 'Hamburger',
	weight = 350,
	stack = true,
	close = true,
	description = "",
	client = {
		status = { hunger = 230000 },
		anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
		prop = { model = 'prop_cs_burger_01', 
		pos = vec3(0.05, -0.02, -0.03), rot = vec3(150.0, 340.0, 170.0) },
		usetime = 7500,
	},
},
```
### For QBCore
* qb-core/shared/items.lua
```lua
    ['delivery_food']                 = {['name'] = 'delivery_food',                   ['label'] = 'Delivery Food',                  ['weight'] = 300,          ['type'] = 'item',         ['image'] = 'delivery_food.png',         ['unique'] = true,          ['useable'] = false,      ['shouldClose'] = true,      ['combinable'] = nil,   ['description'] = 'Grab food!?'},
    ['burger']                 = {['name'] = 'burger',                   ['label'] = 'Burger',                  ['weight'] = 300,          ['type'] = 'item',         ['image'] = 'burger.png',         ['unique'] = true,          ['useable'] = false,      ['shouldClose'] = true,      ['combinable'] = nil,   ['description'] = 'nom nom'},

```

## Configuration

### Language

* Add to server.cfg

```cfg
setr ox:locale en
```

## server.cfg

```cfg
ensure FRAMEWORK # es_extended / qb-core
ensure ox_lib
ensure TARGET # ox_target / qb-target
ensure INVENTORY # ox_inventory / qb-inventory / lj-inventory
ensure kloud-food-delivery
```

# Support & Suggestions
    
Join My [Discord Server](https://discord.gg/DbqC2SWzJk) for Support and Updates!
