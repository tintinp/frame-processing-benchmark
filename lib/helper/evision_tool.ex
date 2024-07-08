defmodule Helper.EvisionTool do
  alias Evision.Mat
  alias Evision.Constant
  alias Evision.InterpolationFlags
  alias Evision, as: CV

  def brg_to_yuv_bin(img_path) do
    img_mat = CV.imread(img_path)
    {height, width, _channel} = Mat.shape(img_mat)
    half_width = div(width, 2)
    half_height = div(height, 2)

    img_yuv_mat = CV.cvtColor(img_mat, Constant.cv_COLOR_BGR2YUV())

    [y_mat, u_mat, v_mat] = CV.split(img_yuv_mat)

    u_mat =
      CV.resize(u_mat, {half_width, half_height},
        fx: 0,
        fy: 0,
        interpolation: InterpolationFlags.cv_INTER_NEAREST()
      )

    v_mat =
      CV.resize(v_mat, {half_width, half_height},
        fx: 0,
        fy: 0,
        interpolation: InterpolationFlags.cv_INTER_NEAREST()
      )

    y_bin = Mat.to_binary(y_mat)
    u_bin = Mat.to_binary(u_mat)
    v_bin = Mat.to_binary(v_mat)

    y_bin <> u_bin <> v_bin
  end

  def yuv_to_bgr_bin(yuv_bin, height, width) do
    half_width = div(width, 2)
    half_height = div(height, 2)
    y_plane_size = width * height
    uv_plane_size = half_width * half_height

    <<y_plane::binary-size(y_plane_size), u_plane::binary-size(uv_plane_size),
      v_plane::binary-size(uv_plane_size)>> = yuv_bin

    y_mat = Mat.from_binary(y_plane, :u8, height, width, 1)
    u_mat = Mat.from_binary(u_plane, :u8, half_height, half_width, 1)
    v_mat = Mat.from_binary(v_plane, :u8, half_height, half_width, 1)

    u_mat =
      CV.resize(u_mat, {width, height},
        fx: 0,
        fy: 0,
        interpolation: InterpolationFlags.cv_INTER_NEAREST()
      )

    v_mat =
      CV.resize(v_mat, {width, height},
        fx: 0,
        fy: 0,
        interpolation: InterpolationFlags.cv_INTER_NEAREST()
      )

    yuv_mat = CV.merge([y_mat, u_mat, v_mat])
    bgr_mat = CV.cvtColor(yuv_mat, Constant.cv_COLOR_YUV2BGR())
    Base.encode64(CV.imencode(".jpg", bgr_mat))
  end
end
