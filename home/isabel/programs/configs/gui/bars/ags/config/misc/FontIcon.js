import Gtk from "gi://Gtk";
import { createCtor } from "resource:///com/github/Aylur/ags/widget.js";
import GObject from "gi://GObject";
import AgsLabel from "resource:///com/github/Aylur/ags/widgets/label.js";

export default createCtor(
  class FontIcon extends AgsLabel {
    static {
      GObject.registerClass(this);
    }

    /** @param {string | import('types/widgets/label').Props & { icon?: string }} params */
    constructor(params = "") {
      const { icon = "", ...rest } = params;
      super(typeof params === "string" ? {} : rest);
      this.toggleClassName("font-icon");

      if (typeof params === "object") this.icon = icon;

      if (typeof params === "string") this.icon = params;
    }

    get icon() {
      return this.label;
    }
    set icon(icon) {
      this.label = icon;
    }

    get size() {
      return this.get_style_context().get_property(
        "font-size",
        Gtk.StateFlags.NORMAL,
      );
    }

    /** @returns {[number, number]} */
    vfunc_get_preferred_height() {
      return [this.size, this.size];
    }

    /** @returns {[number, number]} */
    vfunc_get_preferred_width() {
      return [this.size, this.size];
    }
  },
);
