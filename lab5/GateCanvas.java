import java.awt.*;

public class GateCanvas extends Canvas
{
    boolean inverted;
    int type; // 0 (zero) -- always vertical line
              // 1 (one)  -- if (inverted) then draw not gate
   public GateCanvas(int type_param)
   {
      super();
      // setBackgroundColor( );
      type = type_param;
      inverted = false;
      // setSize(24, 24);
      setVisible(true);
   }  // end constructor

   public void setInverted(boolean inverted_param)
   {
      inverted = inverted_param;
      repaint();
   } // end setInverted()

   public void paint(Graphics g)
   {
      int width = getWidth();
      int height = getHeight();

       if ( (0 == type) || (!inverted) )  // draw vertical line
       {
          g.drawLine(width / 2, 0, width / 2, height);
          // old code for 24 x 24
          // g.drawLine(12, 0, 12, 24);
       }
       else  // draw invertor
       {
          g.setColor(Color.black);
          g.drawLine(width / 2, 0, width / 2, height / 4);
          g.drawLine(width / 5, height / 4, (4 * width)/ 5, height / 4);
          g.drawLine((4 * width)/ 5, height/ 4, width / 2 ,(3*height) / 4);
          g.drawLine(width/ 2, (3*height) / 4, width / 5, height / 4);
          g.fillOval(width / 2 - (height / 8),     // upper left corner
                        (3 * height)/ 4 + 2 - (height /8) ,
                         height / 4, height / 4);   // Diameter is height / 4
          g.drawLine(width / 2, (3 * height) / 4 + 2, width /2, height);
          // old code for 24x24 grid
          //g.drawLine(12, 0, 12, 5);
          //g.drawLine(5, 5, 19, 5);
          //g.drawLine(19, 5, 12, 15);
          //g.drawLine(12, 15, 5, 5);
          //g.fillOval(9, 12, 6, 6);
          //g.setColor(Color.black);
          //g.drawLine(12, 17, 12, 24);
       }
   }  // end paint
   
} // end class Canvas
