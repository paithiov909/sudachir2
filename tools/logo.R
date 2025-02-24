sysfonts::font_add_google("Orbitron")

hexSticker::sticker(
  "https://rawcdn.githack.com/WorksApplications/sudachi.rs/8e087242c00f4a6f773c0043ef20e91b12f0e9b8/logo.png",
  s_x = 0.975,
  s_y = 1.125,
  s_width = .75,
  s_height = .75,
  p_x = 1.10,
  p_y = 0.48,
  p_color = "#0d1000",
  p_family = "Orbitron",
  p_fontface = "bold",
  p_size = 16,
  h_size = 1.8,
  h_fill = "#FEFEFE",
  h_color = "#7c9a00", # "#bce800",
  package = "sudachir2",
  filename = here::here("man/figures/logo-original.png")
)

usethis::use_logo(
  here::here("man/figures/logo-original.png")
)
