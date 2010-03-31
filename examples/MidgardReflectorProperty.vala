/* valac --debug --pkg midgard2 -o midgard-reflector-property MidgardReflectorProperty.vala --vapidir=../ */

using GLib;
using Midgard;


void main() {

	Midgard.init();

	Midgard.Config config = new Midgard.Config();
	try {
		config.read_file ("midgard_test", true);
	} catch ( GLib.Error e) {

	}

	Midgard.Connection cnc = new Midgard.Connection();
	if (!cnc.open_config (config))
		GLib.error ("Not connected to database \n");
	
	/* Initialize reflector for midgard_page class */
	Midgard.ReflectorProperty reflector = new Midgard.ReflectorProperty ("midgard_page");

	/* Check if property style is a link and can hold reference to other object */
	if (reflector.is_link ("style")) {
		string link_class = reflector.get_link_name ("style");
		string link_property = reflector.get_link_target ("style");
		GLib.print ("'style' property is a link to '%s' property of '%s' class \n", link_property, link_class);
	}

	/* Get description and type of style property */
	string description = reflector.description ("style");
	//GLib.Type type = GLib.Type ();
	//string style_type = GLib.Type.name (reflector.get_midgard_type ("style"));
	//GLib.print ("'style' property is of %s type. Described: %s \n", style_type, description);
	GLib.print ("'style' property description: %s \n", description);
}
