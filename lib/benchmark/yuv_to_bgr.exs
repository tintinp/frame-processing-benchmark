# list = Enum.to_list(1..10_000)
# map_fun = fn i -> [i, i * i] end

res_720p = "tanzania_1280x720.jpg"
res_2MP = "tanzania_1920x1080.jpg"
res_4MP = "tanzania_2560x1440.jpg"
res_8MP = "tanzania_3840x2160.jpg"

alias Helper.EvisionTool
alias Helper.ImageTool
alias Evision.InterpolationFlags
alias Evision.Constant
alias Evision.Mat
alias Evision, as: CV

img_path_720p = Path.join([File.cwd!(), "priv/images", res_720p])
img_path_2MP = Path.join([File.cwd!(), "priv/images", res_2MP])
img_path_4MP = Path.join([File.cwd!(), "priv/images", res_4MP])
img_path_8MP = Path.join([File.cwd!(), "priv/images", res_8MP])

img_yuv_bin_720p = EvisionTool.brg_to_yuv_bin(img_path_720p)
img_yuv_bin_2MP = EvisionTool.brg_to_yuv_bin(img_path_2MP)
img_yuv_bin_4MP = EvisionTool.brg_to_yuv_bin(img_path_4MP)
img_yuv_bin_8MP = EvisionTool.brg_to_yuv_bin(img_path_8MP)

Benchee.run(
  %{
    "Evision_720p" => fn -> EvisionTool.yuv_to_bgr_bin(img_yuv_bin_720p, 720, 1280) end,
    "Evision_2MP" => fn -> EvisionTool.yuv_to_bgr_bin(img_yuv_bin_2MP, 1080, 1920) end,
    "Evision_4MP" => fn -> EvisionTool.yuv_to_bgr_bin(img_yuv_bin_4MP, 1440, 2560) end,
    "Evision_8MP" => fn -> EvisionTool.yuv_to_bgr_bin(img_yuv_bin_8MP, 2160, 3840) end,
    "Image_720p" => fn -> ImageTool.yuv_to_bgr_bin(img_yuv_bin_720p, 720, 1280) end,
    "Image_2MP" => fn -> ImageTool.yuv_to_bgr_bin(img_yuv_bin_2MP, 1080, 1920) end,
    "Image_4MP" => fn -> ImageTool.yuv_to_bgr_bin(img_yuv_bin_4MP, 1440, 2560) end,
    "Image_8MP" => fn -> ImageTool.yuv_to_bgr_bin(img_yuv_bin_8MP, 2160, 3840) end
  },
  time: 10,
  memory_time: 2
)
