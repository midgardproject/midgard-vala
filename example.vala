/* valac --debug --pkg midgard2 -c example.vala --vapidir=./ */

using GLib;
using Midgard;

namespace MidgardValaExample {

	void main() {
	
		Midgard.Config config = new Midgard.Config();
		/*try {
			config.read_file ("midgard", true);
		} catch ( GLib.Error e) {

		}*/

		Midgard.Connection cnc = new Midgard.Connection();
		cnc.open_config (config);

		Midgard.QueryBuilder builder = new Midgard.QueryBuilder (cnc, "midgard_page");
		uint n_objects = 0;
		uint i = 0;
		var objects = builder.execute(n_objects);
	}
}
