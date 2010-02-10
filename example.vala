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

		/* cnc.set_loglevel ("debug", null); */

		Midgard.Object page = new Midgard.Object (cnc, "midgard_page", null);
		page.set ("name", "Hello Vala");
		if (page.create()) {
			string pname;
			page.get ("name", out pname);
			Midgard.Timestamp created = page.metadata.created;
			GLib.print ("Created new page '%s' identified by guid %s at %s \n", pname, page.guid, created.get_string());
		}
		else { 
			GLib.print ("Couldn't create new page because: %s \n", cnc.get_error_string());
		}

		Midgard.QueryBuilder builder = new Midgard.QueryBuilder (cnc, "midgard_page");
		unowned GLib.Object[] objects = builder.execute ();

		foreach (GLib.Object object in objects){
		
			string guid;
			object.get ("guid", out guid);	
			GLib.print ("Object %s \n", guid);
		}
	}
}
