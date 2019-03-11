import java.awt.*;

public class FullAdderCanvas extends Canvas
{

   public FullAdderCanvas()
   {
      super();
      // setBackgroundColor( );
      // setSize(WIDTH, HEIGHT);
      setVisible(true);
   }  // end constructor

   public void paint(Graphics g)
   {
      int width = getWidth();
      int height = getHeight();

      g.setColor(Color.black);
      g.drawRect(0, 0, width - 1, height - 1);
      g.drawString("FULL", (width / 8), height / 3);
      g.drawString("ADDER", (width / 8) + 10, (2 * height) / 3);
   }  // end paint
   
} // end class FullAdderCanvas
