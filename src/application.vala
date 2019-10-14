namespace Rehat {
    public class Application : Gtk.Application {
        public Application () {
            Object(
                application_id: "id.sucipto.rehat",
                flags: ApplicationFlags.FLAGS_NONE
            );
        }

        protected override void activate() {
            var window = new Window(this);

            window.show_all();
        }

        public static int main(string[] args) {
            var app = new Application();
            return app.run(args);
        }
    }
}
