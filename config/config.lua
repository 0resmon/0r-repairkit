Config = {}

Config.Framework = 'es_extended' -- 'qb-core', 'qbx_core', 'es_extended'
Config.Interaction = 'ox_target' -- 'ox_target', 'ox_target'

Config.ItemSettings = {
    Name = 'repairkit',
    Distance = 5.0,
}

Config.ItemDelete = true

Config.Job = {
    ['mechanic'] = {
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = false,
    },
    ['ambulance'] = {
        [0] = false,
        [1] = true,
    },
}

Config.Inventory = 'ox_inventory'

Config.Locale = 'en'

Config.KeyType = 'numbers' -- 'letters', 'numbers'

Config.Object = {
    Toolbox = 'prop_toolchest_01',
    Wheels = 'prop_wheel_03',
}

Config.Animation = {
    Hold = {
        Toolbox = {
            -- CreateObject
            animDictionary = 'move_weapon@jerrycan@generic',
            animName = 'idle',
            blendInSpeed = 8.0,
            blendOutSpeed = -8.0,
            duration = -1,
            flag = 50,
            playbackRate = 0,
            lockX = false,
            lockY = false,
            lockZ = false,
            -- Attach
            xPos = 0.43,
            yPos = 0.0,
            zPos = -0.07,
            xRot = 0.0,
            yRot = -800.0,
            zRot = 90.06,
            p9 = true,
            useSoftPinning = true,
            collision = false,
            isPed = true,
            rotationOrder = 1,
            syncRot = true,
        },
        wheels = {
            animDictionary = 'anim@heists@box_carry@',
            animName = 'idle',
            blendInSpeed = 8.0,
            blendOutSpeed = -8.0,
            duration = -1,
            flag = 50,
            playbackRate = 0,
            lockX = false,
            lockY = false,
            lockZ = false,
            -- Attach
            xPos = 0.2,
            yPos = 0.0,
            zPos = -0.20,
            xRot = 180.0,
            yRot = 0.0,
            zRot = 0.0,
            p9 = true,
            useSoftPinning = true,
            collision = false,
            isPed = true,
            rotationOrder = 1,
            syncRot = true,
        },
    },
    Repair = {
        engine = {
            animDictionary = 'mini@repair',
            animName = 'fixing_a_ped',
        },
        body = {
            animDictionary = 'mini@repair',
            animName = 'fixing_a_ped',
        },
        petrolTank = {
            animDictionary = 'mini@repair',
            animName = 'fixing_a_ped',
        },
        wheels = {
            animDictionary = 'mp_car_bomb',
            animName = 'car_bomb_mechanic',
        }
    }
}

Config.Parts = {
    ['engine'] = {
        label = 'Engine',
        description = 'This is the engine of the vehicle.',
    },
    ['body'] = {
        label = 'Body',
        description = 'This is the body of the vehicle.',
    },
    ['petrolTank'] = {
        label = 'Petrol Tank',
        description = 'This is the petrol tank of the vehicle.',
    },
    ['wheels'] = {
        label = 'Wheel',
        description = 'These are the wheels of the vehicle.',
    },
}

Config.Difficulty = {
    engine = {
        Number = 6,
        Time = 6,
    },
    body = {
        Number = 4,
        Time = 4,
    },
    petrolTank = {
        Number = 4,
        Time = 4,
    },
    wheels = {
        Number = 4,
        Time = 4,
    },
}