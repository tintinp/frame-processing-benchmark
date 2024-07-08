defmodule Helper.ImageTool do
  def yuv_to_bgr_bin(yuv_bin, height, width) do
    {:ok, image} =
      Image.YUV.new_from_binary(
        yuv_bin,
        width,
        height,
        :C420,
        :bt601
      )

    {:ok, binary} = Vix.Vips.Image.write_to_buffer(image, ".jpg[Q=75]")
    Base.encode64(binary)
  end
end
