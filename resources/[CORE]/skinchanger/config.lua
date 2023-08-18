Config = {}

Config.Locale = GetConvar('esx:locale', 'en')

Config.Components = {{
    label = TranslateCap('sex'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'sex',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65
}, 
{
    label = "Kolor skóry",
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'skin',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65
}, 
{
    label = "Kolor skóry 2",
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'skin2',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65
}, 
{
    label = "Kolor skóry 3",
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'skin3',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65
},{
    label = "Twarz",
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'face',
    value = 1,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65
},{
    label = "Twarz 2",
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'face2',
    value = 1,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65
},{
    label = "Twarz 3",
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'face3',
    value = 1,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65
},{
    label = "Blend Twarzy",
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'blend',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
},{
    label = "Blend Koloru Skóry",
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'skin_blend',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
},{
    label = "Blend Trzecich Wariantow",
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'blend2',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
},{
    label = TranslateCap('nose_1'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'nose_1',
    value = 0,
    min = -10,
    zoomOffset = 0.6,
    camOffset = 0.65
}, {
    label = TranslateCap('nose_2'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'nose_2',
    value = 0,
    min = -10,
    zoomOffset = 0.6,
    camOffset = 0.65
}, {
    label = TranslateCap('nose_3'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'nose_3',
    value = 0,
    min = -10,
    zoomOffset = 0.6,
    camOffset = 0.65
}, {
    label = TranslateCap('nose_4'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'nose_4',
    value = 0,
    min = -10,
    zoomOffset = 0.6,
    camOffset = 0.65
}, {
    label = TranslateCap('nose_5'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'nose_5',
    value = 0,
    min = -10,
    zoomOffset = 0.6,
    camOffset = 0.65
}, {
    label = TranslateCap('nose_6'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'nose_6',
    value = 0,
    min = -10,
    zoomOffset = 0.6,
    camOffset = 0.65
}, {
    label = TranslateCap('cheeks_1'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'cheeks_1',
    value = 0,
    min = -10,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('cheeks_2'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'cheeks_2',
    value = 0,
    min = -10,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('cheeks_3'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'cheeks_3',
    value = 0,
    min = -10,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('lip_fullness'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'lip_thickness',
    value = 0,
    min = -10,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('jaw_bone_width'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'jaw_1',
    value = 0,
    min = -10,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('jaw_bone_length'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'jaw_2',
    value = 0,
    min = -10,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('chin_height'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'chin_1',
    value = 0,
    min = -10,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('chin_length'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'chin_2',
    value = 0,
    min = -10,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('chin_width'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'chin_3',
    value = 0,
    min = -10,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('chin_hole'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'chin_4',
    value = 0,
    min = -10,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('neck_thickness'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'neck_thickness',
    value = 0,
    min = -10,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('hair_1'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'hair_1',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65
}, {
    label = TranslateCap('hair_2'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'hair_2',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65
}, {
    label = "Pokrycie głowy",
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'hair_3',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65
}, {
    label = TranslateCap('hair_color_1'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'hair_color_1',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65
}, {
    label = TranslateCap('hair_color_2'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'hair_color_2',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65
}, {
    label = TranslateCap('tshirt_1'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'tshirt_1',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15,
    componentId = 8
}, {
    label = TranslateCap('tshirt_2'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'tshirt_2',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15,
    textureof = 'tshirt_1'
}, {
    label = TranslateCap('torso_1'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'torso_1',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15,
    componentId = 11
}, {
    label = TranslateCap('torso_2'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'torso_2',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15,
    textureof = 'torso_1'
}, {
    label = TranslateCap('decals_1'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'decals_1',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15,
    componentId = 10
}, {
    label = TranslateCap('decals_2'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'decals_2',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15,
    textureof = 'decals_1'
}, {
    label = TranslateCap('arms'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'arms',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15
}, {
    label = TranslateCap('arms_2'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'arms_2',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15
}, {
    label = TranslateCap('pants_1'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'pants_1',
    value = 0,
    min = 0,
    zoomOffset = 0.8,
    camOffset = -0.5,
    componentId = 4
}, {
    label = TranslateCap('pants_2'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'pants_2',
    value = 0,
    min = 0,
    zoomOffset = 0.8,
    camOffset = -0.5,
    textureof = 'pants_1'
}, {
    label = TranslateCap('shoes_1'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'shoes_1',
    value = 0,
    min = 0,
    zoomOffset = 0.8,
    camOffset = -0.8,
    componentId = 6
}, {
    label = TranslateCap('shoes_2'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'shoes_2',
    value = 0,
    min = 0,
    zoomOffset = 0.8,
    camOffset = -0.8,
    textureof = 'shoes_1'
}, {
    label = TranslateCap('mask_1'),
    category = {
        name = 'accesories',
        button = TranslateCap('accesories'),
    },
    name = 'mask_1',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65,
    componentId = 1
}, {
    label = TranslateCap('mask_2'),
    category = {
        name = 'accesories',
        button = TranslateCap('accesories'),
    },
    name = 'mask_2',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65,
    textureof = 'mask_1'
}, {
    label = TranslateCap('bproof_1'),
    category = {
        name = 'accesories',
        button = TranslateCap('accesories'),
    },
    name = 'bproof_1',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15,
    componentId = 9
}, {
    label = TranslateCap('bproof_2'),
    category = {
        name = 'accesories',
        button = TranslateCap('accesories'),
    },
    name = 'bproof_2',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15,
    textureof = 'bproof_1'
}, {
    label = TranslateCap('chain_1'),
    category = {
        name = 'accesories',
        button = TranslateCap('accesories'),
    },
    name = 'chain_1',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65,
    componentId = 7
}, {
    label = TranslateCap('chain_2'),
    category = {
        name = 'accesories',
        button = TranslateCap('accesories'),
    },
    name = 'chain_2',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65,
    textureof = 'chain_1'
}, {
    label = TranslateCap('helmet_1'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'helmet_1',
    value = -1,
    min = -1,
    zoomOffset = 0.6,
    camOffset = 0.65,
    componentId = 0
}, {
    label = TranslateCap('helmet_2'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'helmet_2',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65,
    textureof = 'helmet_1'
}, {
    label = TranslateCap('glasses_1'),
    category = {
        name = 'accesories',
        button = TranslateCap('accesories'),
    },
    name = 'glasses_1',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65,
    componentId = 1
}, {
    label = TranslateCap('glasses_2'),
    category = {
        name = 'accesories',
        button = TranslateCap('accesories'),
    },
    name = 'glasses_2',
    value = 0,
    min = 0,
    zoomOffset = 0.6,
    camOffset = 0.65,
    textureof = 'glasses_1'
}, {
    label = TranslateCap('watches_1'),
    category = {
        name = 'accesories',
        button = TranslateCap('accesories'),
    },
    name = 'watches_1',
    value = -1,
    min = -1,
    zoomOffset = 0.75,
    camOffset = 0.15,
    componentId = 6
}, {
    label = TranslateCap('watches_2'),
    category = {
        name = 'accesories',
        button = TranslateCap('accesories'),
    },
    name = 'watches_2',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15,
    textureof = 'watches_1'
}, {
    label = TranslateCap('bracelets_1'),
    category = {
        name = 'accesories',
        button = TranslateCap('accesories'),
    },
    name = 'bracelets_1',
    value = -1,
    min = -1,
    zoomOffset = 0.75,
    camOffset = 0.15,
    componentId = 7
}, {
    label = TranslateCap('bracelets_2'),
    category = {
        name = 'accesories',
        button = TranslateCap('accesories'),
    },
    name = 'bracelets_2',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15,
    textureof = 'bracelets_1'
}, {
    label = TranslateCap('bag'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'bags_1',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15,
    componentId = 5
}, {
    label = TranslateCap('bag_color'),
    category = {
        name = 'clothes',
        button = TranslateCap('clothes'),
    },
    name = 'bags_2',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15,
    textureof = 'bags_1'
}, {
    label = TranslateCap('eye_color'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'eye_color',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('eye_squint'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'eye_squint',
    value = 0,
    min = -10,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('eyebrow_size'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'eyebrows_2',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('eyebrow_type'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'eyebrows_1',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('eyebrow_color_1'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'eyebrows_3',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('eyebrow_color_2'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'eyebrows_4',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('eyebrow_height'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'eyebrows_5',
    value = 0,
    min = -10,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('eyebrow_depth'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'eyebrows_6',
    value = 0,
    min = -10,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('makeup_type'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'makeup_1',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('makeup_thickness'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'makeup_2',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('makeup_color_1'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'makeup_3',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('makeup_color_2'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'makeup_4',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('lipstick_type'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'lipstick_1',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('lipstick_thickness'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'lipstick_2',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('lipstick_color_1'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'lipstick_3',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('lipstick_color_2'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'lipstick_4',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('ear_accessories'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'ears_1',
    value = -1,
    min = -1,
    zoomOffset = 0.4,
    camOffset = 0.65,
    componentId = 2
}, {
    label = TranslateCap('ear_accessories_color'),
    category = {
        name = 'accesories',
        button = TranslateCap('accesories'),
    },
    name = 'ears_2',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65,
    textureof = 'ears_1'
}, {
    label = TranslateCap('chest_hair'),
    category = {
        name = 'accesories',
        button = TranslateCap('accesories'),
    },
    name = 'chest_1',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15
}, {
    label = TranslateCap('chest_hair_1'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'chest_2',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15
}, {
    label = TranslateCap('chest_color'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'chest_3',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15
}, {
    label = TranslateCap('bodyb'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'bodyb_1',
    value = -1,
    min = -1,
    zoomOffset = 0.75,
    camOffset = 0.15
}, {
    label = TranslateCap('bodyb_size'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'bodyb_2',
    value = 0,
    min = 0,
    zoomOffset = 0.75,
    camOffset = 0.15
}, {
    label = TranslateCap('bodyb_extra'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'bodyb_3',
    value = -1,
    min = -1,
    zoomOffset = 0.4,
    camOffset = 0.15
}, {
    label = TranslateCap('bodyb_extra_thickness'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'bodyb_4',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.15
}, {
    label = TranslateCap('wrinkles'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'age_1',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('wrinkle_thickness'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'age_2',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('blemishes'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'blemishes_1',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('blemishes_size'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'blemishes_2',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('blush'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'blush_1',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('blush_1'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'blush_2',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('blush_color'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'blush_3',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('complexion'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'complexion_1',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('complexion_1'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'complexion_2',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('sun'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'sun_1',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('sun_1'),
    category = {
        name = 'body',
        button = TranslateCap('body'),
    },
    name = 'sun_2',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('freckles'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'moles_1',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('freckles_1'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'moles_2',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('beard_type'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'beard_1',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('beard_size'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'beard_2',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('beard_color_1'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'beard_3',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}, {
    label = TranslateCap('beard_color_2'),
    category = {
        name = 'face',
        button = TranslateCap('face'),
    },
    name = 'beard_4',
    value = 0,
    min = 0,
    zoomOffset = 0.4,
    camOffset = 0.65
}}

Config.HairDecorations = {
    {
		{`mpbeach_overlays`,`FM_Hair_Fuzz`},
		{`multiplayer_overlays`,`FM_M_Hair_001_a`},
		{`multiplayer_overlays`,`FM_M_Hair_001_b`},
		{`multiplayer_overlays`,`FM_M_Hair_001_c`},
		{`multiplayer_overlays`,`FM_M_Hair_001_d`},
		{`multiplayer_overlays`,`FM_M_Hair_001_e`},
		{`multiplayer_overlays`,`FM_M_Hair_003_a`},
		{`multiplayer_overlays`,`FM_M_Hair_003_b`},
		{`multiplayer_overlays`,`FM_M_Hair_003_c`},
		{`multiplayer_overlays`,`FM_M_Hair_003_d`},
		{`multiplayer_overlays`,`FM_M_Hair_003_e`},
		{`multiplayer_overlays`,`FM_M_Hair_006_a`},
		{`multiplayer_overlays`,`FM_M_Hair_006_b`},
		{`multiplayer_overlays`,`FM_M_Hair_006_c`},
		{`multiplayer_overlays`,`FM_M_Hair_006_d`},
		{`multiplayer_overlays`,`FM_M_Hair_006_e`},
		{`multiplayer_overlays`,`FM_M_Hair_008_a`},
		{`multiplayer_overlays`,`FM_M_Hair_008_b`},
		{`multiplayer_overlays`,`FM_M_Hair_008_c`},
		{`multiplayer_overlays`,`FM_M_Hair_008_d`},
		{`multiplayer_overlays`,`FM_M_Hair_008_e`},
		{`multiplayer_overlays`,`FM_M_Hair_long_a`},
		{`multiplayer_overlays`,`FM_M_Hair_long_b`},
		{`multiplayer_overlays`,`FM_M_Hair_long_c`},
		{`multiplayer_overlays`,`FM_M_Hair_long_d`},
		{`multiplayer_overlays`,`FM_M_Hair_long_e`},
		{`multiplayer_overlays`,`NG_M_Hair_001`},
		{`multiplayer_overlays`,`NG_M_Hair_002`},
		{`multiplayer_overlays`,`NG_M_Hair_003`},
		{`multiplayer_overlays`,`NG_M_Hair_004`},
		{`multiplayer_overlays`,`NG_M_Hair_005`},
		{`multiplayer_overlays`,`NG_M_Hair_006`},
		{`multiplayer_overlays`,`NG_M_Hair_007`},
		{`multiplayer_overlays`,`NG_M_Hair_008`},
		{`multiplayer_overlays`,`NG_M_Hair_009`},
		{`multiplayer_overlays`,`NG_M_Hair_010`},
		{`multiplayer_overlays`,`NG_M_Hair_011`},
		{`multiplayer_overlays`,`NG_M_Hair_012`},
		{`multiplayer_overlays`,`NG_M_Hair_013`},
		{`multiplayer_overlays`,`NG_M_Hair_014`},
		{`multiplayer_overlays`,`NG_M_Hair_015`},
		{`multiplayer_overlays`,`NGBea_M_Hair_000`},
		{`multiplayer_overlays`,`NGBea_M_Hair_001`},
		{`multiplayer_overlays`,`NGBus_M_Hair_000`},
		{`multiplayer_overlays`,`NGBus_M_Hair_001`},
		{`multiplayer_overlays`,`NGHip_M_Hair_000`},
		{`multiplayer_overlays`,`NGHip_M_Hair_001`},
		{`multiplayer_overlays`,`NGInd_M_Hair_000`},
		{`mphipster_overlays`,`FM_Hip_M_Hair_000_a`},
		{`mphipster_overlays`,`FM_Hip_M_Hair_000_b`},
		{`mphipster_overlays`,`FM_Hip_M_Hair_000_c`},
		{`mphipster_overlays`,`FM_Hip_M_Hair_000_d`},
		{`mphipster_overlays`,`FM_Hip_M_Hair_000_e`},
		{`mphipster_overlays`,`FM_Hip_M_Hair_001_a`},
		{`mphipster_overlays`,`FM_Hip_M_Hair_001_b`},
		{`mphipster_overlays`,`FM_Hip_M_Hair_001_c`},
		{`mphipster_overlays`,`FM_Hip_M_Hair_001_d`},
		{`mphipster_overlays`,`FM_Hip_M_Hair_001_e`},
		{`mphipster_overlays`,`FM_Disc_M_Hair_001_a`},
		{`mphipster_overlays`,`FM_Disc_M_Hair_001_b`},
		{`mphipster_overlays`,`FM_Disc_M_Hair_001_c`},
		{`mphipster_overlays`,`FM_Disc_M_Hair_001_d`},
		{`mphipster_overlays`,`FM_Disc_M_Hair_001_e`},
		{`mpbiker_overlays`,`MP_Biker_Hair_000_M`},
		{`mpbiker_overlays`,`MP_Biker_Hair_001_M`},
		{`mpbiker_overlays`,`MP_Biker_Hair_002_M`},
		{`mpbiker_overlays`,`MP_Biker_Hair_003_M`},
		{`mpbiker_overlays`,`MP_Biker_Hair_004_M`},
		{`mpbiker_overlays`,`MP_Biker_Hair_005_M`},
		{`mpbiker_overlays`,`MP_Biker_Hair_006_M`},
		{`mpgunrunning_overlays`,`MP_Gunrunning_Hair_M_000_M`},
		{`mpgunrunning_overlays`,`MP_Gunrunning_Hair_M_001_M`},
		{`mplowrider_overlays`,`LR_M_Hair_000`},
		{`mplowrider_overlays`,`LR_M_Hair_001`},
		{`mplowrider_overlays`,`LR_M_Hair_002`},
		{`mplowrider_overlays`,`LR_M_Hair_003`},
		{`mplowrider2_overlays`,`LR_M_Hair_004`},
		{`mplowrider2_overlays`,`LR_M_Hair_005`},
		{`mplowrider2_overlays`,`LR_M_Hair_006`},
		{`mpbusiness_overlays`,`FM_Bus_M_Hair_000_a`},
		{`mpbusiness_overlays`,`FM_Bus_M_Hair_000_b`},
		{`mpbusiness_overlays`,`FM_Bus_M_Hair_000_c`},
		{`mpbusiness_overlays`,`FM_Bus_M_Hair_000_d`},
		{`mpbusiness_overlays`,`FM_Bus_M_Hair_000_e`},
		{`mpbusiness_overlays`,`FM_Bus_M_Hair_001_a`},
		{`mpbusiness_overlays`,`FM_Bus_M_Hair_001_b`},
		{`mpbusiness_overlays`,`FM_Bus_M_Hair_001_c`},
		{`mpbusiness_overlays`,`FM_Bus_M_Hair_001_d`},
		{`mpbusiness_overlays`,`FM_Bus_M_Hair_001_e`}
	},
	{
		{`mpbeach_overlays`,`FM_Hair_Fuzz`},
		{`multiplayer_overlays`,`FM_F_Hair_003_a`},
		{`multiplayer_overlays`,`FM_F_Hair_003_b`},
		{`multiplayer_overlays`,`FM_F_Hair_003_c`},
		{`multiplayer_overlays`,`FM_F_Hair_003_d`},
		{`multiplayer_overlays`,`FM_F_Hair_003_e`},
		{`multiplayer_overlays`,`FM_F_Hair_005_a`},
		{`multiplayer_overlays`,`FM_F_Hair_005_b`},
		{`multiplayer_overlays`,`FM_F_Hair_005_c`},
		{`multiplayer_overlays`,`FM_F_Hair_005_d`},
		{`multiplayer_overlays`,`FM_F_Hair_005_e`},
		{`multiplayer_overlays`,`FM_F_Hair_006_a`},
		{`multiplayer_overlays`,`FM_F_Hair_006_b`},
		{`multiplayer_overlays`,`FM_F_Hair_006_c`},
		{`multiplayer_overlays`,`FM_F_Hair_006_d`},
		{`multiplayer_overlays`,`FM_F_Hair_006_e`},
		{`multiplayer_overlays`,`FM_F_Hair_013_a`},
		{`multiplayer_overlays`,`FM_F_Hair_013_b`},
		{`multiplayer_overlays`,`FM_F_Hair_013_c`},
		{`multiplayer_overlays`,`FM_F_Hair_013_d`},
		{`multiplayer_overlays`,`FM_F_Hair_013_e`},
		{`multiplayer_overlays`,`FM_F_Hair_014_a`},
		{`multiplayer_overlays`,`FM_F_Hair_014_b`},
		{`multiplayer_overlays`,`FM_F_Hair_014_c`},
		{`multiplayer_overlays`,`FM_F_Hair_014_d`},
		{`multiplayer_overlays`,`FM_F_Hair_014_e`},
		{`multiplayer_overlays`,`FM_F_Hair_long_a`},
		{`multiplayer_overlays`,`FM_F_Hair_long_b`},
		{`multiplayer_overlays`,`FM_F_Hair_long_c`},
		{`multiplayer_overlays`,`FM_F_Hair_long_d`},
		{`multiplayer_overlays`,`FM_F_Hair_long_e`},
		{`multiplayer_overlays`,`NG_F_Hair_001`},
		{`multiplayer_overlays`,`NG_F_Hair_002`},
		{`multiplayer_overlays`,`NG_F_Hair_003`},
		{`multiplayer_overlays`,`NG_F_Hair_004`},
		{`multiplayer_overlays`,`NG_F_Hair_005`},
		{`multiplayer_overlays`,`NG_F_Hair_006`},
		{`multiplayer_overlays`,`NG_F_Hair_007`},
		{`multiplayer_overlays`,`NG_F_Hair_008`},
		{`multiplayer_overlays`,`NG_F_Hair_009`},
		{`multiplayer_overlays`,`NG_F_Hair_010`},
		{`multiplayer_overlays`,`NG_F_Hair_011`},
		{`multiplayer_overlays`,`NG_F_Hair_012`},
		{`multiplayer_overlays`,`NG_F_Hair_013`},
		{`multiplayer_overlays`,`NG_F_Hair_014`},
		{`multiplayer_overlays`,`NG_F_Hair_015`},
		{`multiplayer_overlays`,`NGBea_F_Hair_000`},
		{`multiplayer_overlays`,`NGBea_F_Hair_001`},
		{`multiplayer_overlays`,`NGBus_F_Hair_000`},
		{`multiplayer_overlays`,`NGBus_F_Hair_001`},
		{`multiplayer_overlays`,`NGHip_F_Hair_000`},
		{`multiplayer_overlays`,`NGHip_F_Hair_001`},
		{`multiplayer_overlays`,`NGInd_F_Hair_000`},
		{`mphipster_overlays`,`FM_Hip_F_Hair_000_a`},
		{`mphipster_overlays`,`FM_Hip_F_Hair_000_b`},
		{`mphipster_overlays`,`FM_Hip_F_Hair_000_c`},
		{`mphipster_overlays`,`FM_Hip_F_Hair_000_d`},
		{`mphipster_overlays`,`FM_Hip_F_Hair_000_e`},
		{`mphipster_overlays`,`FM_F_Hair_017_a`},
		{`mphipster_overlays`,`FM_F_Hair_017_b`},
		{`mphipster_overlays`,`FM_F_Hair_017_c`},
		{`mphipster_overlays`,`FM_F_Hair_017_d`},
		{`mphipster_overlays`,`FM_F_Hair_017_e`},
		{`mphipster_overlays`,`FM_F_Hair_020_a`},
		{`mphipster_overlays`,`FM_F_Hair_020_b`},
		{`mphipster_overlays`,`FM_F_Hair_020_c`},
		{`mphipster_overlays`,`FM_F_Hair_020_d`},
		{`mphipster_overlays`,`FM_F_Hair_020_e`}
	}
}