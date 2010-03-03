/* Example code taken from: http://live.gnome.org/Vala/GTKSample.
To compile:
valac --pkg gtk+-2.0 --pkg midgard2 treeview.vala --vapidir=./
*/

using Gtk;
using Midgard;

public class TreeViewSample : Window {

    public TreeViewSample () {
        this.title = "TreeView Sample";
        set_default_size (350, 200);
        var view = new TreeView ();
        setup_treeview (view);
        add (view);
        this.destroy.connect (Gtk.main_quit);
    }

    private void setup_treeview (TreeView view) {

        /*
         * Use ListStore to hold accountname, accounttype, balance and
         * color attribute. For more info on how TreeView works take a
         * look at the GTK+ API.
         */

	Midgard.Config config = new Midgard.Config();
        try {
		config.read_file ("midgard_test", true);
	} catch ( GLib.Error e) {

        }

	Midgard.Connection cnc = new Midgard.Connection();
        if (!cnc.open_config (config))
		GLib.error ("Not connected to database \n");

	Midgard.QueryBuilder builder = new Midgard.QueryBuilder (cnc, "midgard_page");
		unowned GLib.Object[] objects = builder.execute ();

        var listmodel = new ListStore (4, typeof (string), typeof (string),
                                          typeof (string), typeof (string));
        view.set_model (listmodel);

        view.insert_column_with_attributes (-1, "Page Name", new CellRendererText (), "text", 0);
        view.insert_column_with_attributes (-1, "Guid", new CellRendererText (), "text", 1);

        var cell = new CellRendererText ();
        cell.set ("foreground_set", true);
        view.insert_column_with_attributes (-1, "Created", cell, "text", 2, "foreground", 3);

        TreeIter iter;

        foreach (GLib.Object object in objects){
		string guid;
		string name;
		Midgard.Metadata metadata;
		object.get ("guid", out guid, "name", out name, "metadata", out metadata);
		string created = Midgard.Timestamp.get_string_from_value (metadata.created);
	        listmodel.append (out iter);
        	listmodel.set (iter, 0, name, 1, guid, 2, created, 3, "red");	
        }
    }

    public static int main (string[] args) {     
        Gtk.init (ref args);
	Midgard.init();

        var sample = new TreeViewSample ();
        sample.show_all ();
        Gtk.main ();

        return 0;
    }
}

