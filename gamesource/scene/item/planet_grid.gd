class_name PlanetGrid extends Grid

enum PlanetType
{
	Planet,
	Enemy,
	Boss,
}

var _type:PlanetType=PlanetType.Planet

func set_planet_type(eType):
	_type = eType
	

