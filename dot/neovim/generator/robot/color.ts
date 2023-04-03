import { Hsluv } from "npm:hsluv@1.0.0";

class Color {
  color: Hsluv | "NONE";

  constructor(color: string | Color | Hsluv) {
    this.color = new Hsluv();
    if (typeof color === "string") {
      if (color === "NONE") {
        this.color = "NONE";
        return;
      }
      this.color.hex = color;
    } else {
      this.color.hex = color.hex;
    }
    this.color.hexToHsluv();
  }

  mix(color: Color, percentage: number) {
    if (this.color === "NONE" || color.color === "NONE") {
      return new Color("");
    }
    const new_color = new Hsluv();
    this.color.hsluvToRgb();
    color.color.hsluvToRgb();
    new_color.rgb_r =
      this.color.rgb_r + (color.color.rgb_r - this.color.rgb_r) * percentage;
    new_color.rgb_g =
      this.color.rgb_g + (color.color.rgb_g - this.color.rgb_g) * percentage;
    new_color.rgb_b =
      this.color.rgb_b + (color.color.rgb_b - this.color.rgb_b) * percentage;
    new_color.rgbToHex();
    this.color.rgbToHsluv();
    return new Color(new_color);
  }

  get hex(): string {
    if (this.color === "NONE") {
      return "#000000";
    }
    this.color.hsluvToHex();
    const hex = this.color.hex;
    this.color.hexToHsluv();
    return hex;
  }

  get string(): string {
    if (this.color === "NONE") {
      return "NONE";
    }
    return this.hex;
  }

  /** Hue */
  h(h: number) {
    if (this.color !== "NONE") {
      this.color.hsluv_h = h;
    }
    return this;
  }
  /** Saturation */
  s(s: number) {
    if (this.color !== "NONE") {
      this.color.hsluv_s = s;
    }
    return this;
  }
  /** Lightness */
  l(l: number) {
    if (this.color !== "NONE") {
      this.color.hsluv_l = l;
    }
    return this;
  }
}

function color(color: string | Color) {
  return new Color(color);
}

export { Color, color };
