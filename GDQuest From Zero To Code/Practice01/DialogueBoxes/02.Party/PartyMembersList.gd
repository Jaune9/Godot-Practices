extends VBoxContainer

const members = [
	{"name": "Dani", "texture": preload("../common/portraits/dani_neutral.png")},
	{"name": "Sophia", "texture": preload("../common/portraits/sophia_neutral.png")},
	{"name": "GDBot", "texture": preload("../common/portraits/gdbot.png")},
]


func _ready() -> void:
	# Add all members using a for loop.
	for member in members:
		add_member(member)


func add_member(member: Dictionary) -> void:
	
	# Create an instance of the PartyMember scene, add it as a child.
	var party_member = preload("PartyMember.tscn").instance()
	# You need to first add the party member as a child or you'll get an error.
	add_child(party_member)
	
	# Set the party member's text and texture. See PartyMember.gd to see how.
	party_member.set_text(member["name"])
	party_member.set_texture(member["texture"])
