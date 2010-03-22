/* valac --debug --pkg midgard2 -o midgard-query-select MidgardQuerySelect.vala --vapidir=./ */

using GLib;
using Midgard;

namespace MidgardQueryExample {

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
	
		/* Initialize QueryStorage for given midgard_page class */
		Midgard.QueryStorage storage = new Midgard.QueryStorage ("midgard_page");
		Midgard.QuerySelect select = new Midgard.QuerySelect (cnc, storage);

		/* Add constraints */
		/* 'metadata.created > "2000-01-01 10:10:10"' */
		Midgard.QueryProperty prop1 = new Midgard.QueryProperty ("metadata.created", null);
		Midgard.QueryValue val1 = new Midgard.QueryValue ("2000-01-01 10:10:10");
		Midgard.QueryConstraint cnstr1 = new Midgard.QueryConstraint (prop1, ">", val1, null);

		/* name <> "" */
		Midgard.QueryProperty prop2 = new Midgard.QueryProperty ("name", null);
		Midgard.QueryValue val2 = new Midgard.QueryValue ("");
		Midgard.QueryConstraint cnstr2 = new Midgard.QueryConstraint (prop2, "<>", val2, null);

		/* up <> 0 */
		Midgard.QueryProperty prop3 = new Midgard.QueryProperty ("up", null);
		Midgard.QueryValue val3 = new Midgard.QueryValue (0);
		Midgard.QueryConstraint cnstr3 = new Midgard.QueryConstraint (prop3, "<>", val3, null);

		/* Implicit join on storage which is configured for a class, a style property is link to */
		Midgard.QueryProperty prop4 = new Midgard.QueryProperty ("style.metadata.revised", null);
		Midgard.QueryValue val4 = new Midgard.QueryValue ("2000-01-01 10:10:10");
		Midgard.QueryConstraint cnstr4 = new Midgard.QueryConstraint (prop4, ">", val4, null);

		/* Implicit join on parameters storage */
		Midgard.QueryProperty prop5 = new Midgard.QueryProperty ("parameter.name", null);
		Midgard.QueryValue val5 = new Midgard.QueryValue ("some domain");
		Midgard.QueryConstraint cnstr5 = new Midgard.QueryConstraint (prop5, "=", val5, null);

		/* Implicit join on attachments storage */
		Midgard.QueryProperty prop6 = new Midgard.QueryProperty ("attachment.name", null);
		Midgard.QueryValue val6 = new Midgard.QueryValue ("my attachment");
		Midgard.QueryConstraint cnstr6 = new Midgard.QueryConstraint (prop6, "=", val6, null);
	
		/* Create two constraints group */
		Midgard.QueryGroupConstraint group_constraint_and = new Midgard.QueryGroupConstraint ("AND", cnstr4, cnstr5, cnstr6);

		Midgard.QueryGroupConstraint group_constraint = new Midgard.QueryGroupConstraint ("OR", cnstr1, cnstr2, cnstr3, group_constraint_and);

		/* Add explicit joins */
		Midgard.QueryProperty prop7 = new Midgard.QueryProperty ("metadata.creator", null);
		Midgard.QueryStorage join_storage = new Midgard.QueryStorage ("midgard_person");
		Midgard.QueryProperty prop8 = new Midgard.QueryProperty ("guid", join_storage);

		Midgard.QueryProperty prop9 = new Midgard.QueryProperty ("metadata.creator", null);
		Midgard.QueryStorage join_storage1 = new Midgard.QueryStorage ("midgard_page");
		Midgard.QueryProperty prop10 = new Midgard.QueryProperty ("metadata.revisor", join_storage1);

		select.add_join ("LEFT", prop7, prop8);
		select.add_join ("LEFT", prop9, prop10);

		/* Set constraint */
		select.set_constraint (group_constraint);

		/* Set limit */
		select.set_limit (1);

		/* Set offset */
		select.set_offset (2);

		/* Add orders */
		select.add_order (prop6, "asc");
		select.add_order (prop1, "desc");
		select.add_order (prop1, "desc"); 
		
		GLib.Timer timer = new GLib.Timer();
		timer.start();
		select.set_limit (20);

		/* Select object in read/write mode */
		select.toggle_read_only (false);

		/* Execute query only. No objects are created (yet) */
		select.execute();
	
		GLib.print ("\nFound %u objects \n", select.get_results_count());
	
		/* Initialize objects selected from storage */
		unowned Midgard.DBObject[] objects = select.list_objects ();

		foreach (Midgard.DBObject _object in objects){
		
			Midgard.Object object = (Midgard.Object) _object;
			string guid;
			object.get ("guid", out guid);
		}
		timer.stop();
		GLib.print ("Elapsed: %.04f \n", timer.elapsed());
	}
}
