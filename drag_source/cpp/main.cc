// This file is published under public domain.

#include "base/command_line.h"
#include "base/files/file_path.h"
#include "nativeui/nativeui.h"

#if defined(OS_WIN)
int WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int) {
  base::CommandLine::Init(0, nullptr);
#else
int main(int argc, const char *argv[]) {
  base::CommandLine::Init(argc, argv);
#endif

  // Intialize GUI toolkit.
  nu::Lifetime lifetime;

  // Initialize the global instance of nativeui.
  nu::State state;

  // Create win and controls.
  scoped_refptr<nu::Window> win(new nu::Window(nu::Window::Options()));
  win->SetContentSize(nu::SizeF(240, 120));
  win->on_close.Connect([](nu::Window*) {
    nu::MessageLoop::Quit();
  });

  nu::Container* content_view = new nu::Container;
  content_view->SetStyle("flexDirection", "row");
  content_view->SetBackgroundColor(nu::Color("#FFF"));
  win->SetContentView(content_view);

  nu::Container* drag = new nu::Container;
  drag->SetStyle("width", 100, "margin", 10);
  drag->SetMouseDownCanMoveWindow(false);
  content_view->AddChildView(drag);

  nu::Container* drop = new nu::Container;
  drop->SetStyle("flex", 1, "margin", 10);
  content_view->AddChildView(drop);

  win->Center();
  win->Activate();

  // The image that will be used as drag data.
  base::FilePath png_path(FILE_PATH_LITERAL("../drag.png"));
  scoped_refptr<nu::Image> image(new nu::Image(png_path));

  // Handle dragging.
  drag->on_draw.Connect([&image](nu::View* self, nu::Painter* painter, const nu::RectF&) {
    nu::RectF rect = self->GetBounds();
    rect.set_x(0);
    rect.set_y(0);
    painter->DrawImage(image.get(), rect);
  });
  drag->on_mouse_down.Connect([&png_path, &image](nu::View* self, const nu::MouseEvent&) {
    std::vector<nu::Clipboard::Data> data;
    data.emplace_back(std::vector<base::FilePath>({png_path}));
    data.emplace_back(image.get());
    self->DoDragWithOptions(std::move(data), nu::DRAG_OPERATION_COPY, nu::DragOptions(image.get()));
    return true;
  });

  // Drawing the dragged data.
  nu::Clipboard::Data data;
  drop->on_draw.Connect([&data](nu::View* self, nu::Painter* painter, const nu::RectF&) {
    painter->SetColor(nu::Color("#F23"));
    nu::RectF rect = self->GetBounds();
    rect.set_x(0);
    rect.set_y(0);
    painter->StrokeRect(rect);

    rect.set_x(1);
    rect.set_y(1);
    rect.set_width(rect.width() - 2);
    rect.set_height(rect.height() - 2);
    if (data.type() == nu::Clipboard::Data::Type::Image) {
      painter->DrawImage(data.image(), rect);
    } else {
      nu::TextAttributes attributes;
      attributes.color = nu::Color("#999");
      attributes.align = nu::TextAlign::Center;
      attributes.valign = nu::TextAlign::Center;
      painter->DrawText("Drag image here", rect, attributes);
    }
  });

  // Handle dropping.
  drop->RegisterDraggedTypes({nu::Clipboard::Data::Type::Image});
  drop->handle_drag_enter = [](nu::View*, nu::DraggingInfo*, const nu::PointF&) {
    return nu::DRAG_OPERATION_COPY;
  };
  drop->handle_drop = [&data](nu::View* self, nu::DraggingInfo* info, const nu::PointF&) {
    data = info->GetData(nu::Clipboard::Data::Type::Image);
    self->SchedulePaint();
    return true;
  };

  // Enter message loop.
  nu::MessageLoop::Run();

  return 0;
}
