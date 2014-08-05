part of timeseries;

class TimeSeries {

  CanvasElement canvas;
  CanvasRenderingContext2D context;

  TimeSeries(this.canvas) {
    context = canvas.context2D;
  }
  
}