/* valac --debug --pkg midgard2 -o midgard-vala-example example.vala --vapidir=./ */

using GLib;
using Midgard;

namespace MidgardValaExample {

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

		Midgard.Object page = new Midgard.Object (cnc, "midgard_page", null);
		page.set ("name", "Hello Vala");
		if (page.create()) {
			string guid;
			page.get ("guid", out guid);
			GLib.print ("Created new page identified by guid %s \n", guid);
		}
		else { 
			GLib.print ("Couldn't create new page because: %s \n", cnc.get_error_string());
		}

		Midgard.QueryBuilder builder = new Midgard.QueryBuilder (cnc, "midgard_page");
		uint n_objects;
		uint i = 0;
		var objects = builder.execute (out n_objects);
	
		GLib.print ("Found %u pages: \n", n_objects);

		while (i < n_objects) {
			
			GLib.print ("%p \n", objects); 
			i++;
		}
	}
}
