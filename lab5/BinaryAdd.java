import java.awt.*;
import java.awt.event.*;

public class BinaryAdd extends Frame implements ActionListener, ItemListener
{
	public final static int TOP = 0;
	public final static int LEFT = 0;
	public final static int NUM_BITS = 4;
	public final static int ADDITION = 0;
	public final static int SUBTRACTION = 1;
	public final static int SIGNED = 10;
	public final static int UNSIGNED = 11;

	int ValueA = 0;
	int ValueB = 0;
	int ValueSum = 0;
	int currentOperation = ADDITION;
	Checkbox addCheckbox;
	Checkbox subtractCheckbox;
	CheckboxGroup cbg_op;
	Checkbox signedCheckbox;
	Checkbox unsignedCheckbox;
	CheckboxGroup numberTypeCBG;
	int numberType = UNSIGNED;
	TextField AValues[]; // Decimal, Hex and Binary
	TextField BValues[]; // Decimal, Hex and Binary
	TextField SumValues[]; // Decimal, Hex and Binary
	Label bitALabel[];
	Label bitBLabel[];
	Label bitSumLabel[];
	Label carryOutLabel[];
	TextField inputBit_A_ValueTextField[];
	TextField inputBit_B_ValueTextField[];
	TextField calcBit_A_ValueTextField[];
	TextField calcBit_B_ValueTextField[];
	TextField resultBit_Sum_ValueTextField[];
	TextField carryOutTextField[];
	TextField carryInTextField;
	TextField N_FlagTextField;
	TextField Z_FlagTextField;
	TextField V_FlagTextField;
	TextField C_FlagTextField;

	ArrowCanvas carryInArrow[];
	ArrowCanvas carryOutArrow[];
	FullAdderCanvas fullAdder[];
	GateCanvas Sum_outputPathCanvas[];

	GateCanvas A_inputPathCanvas[][];
	GateCanvas B_inputPathCanvas[][];   // first index indicates bit number,
	                                // second indicates part of input paths 
	                 //  0 -- vertical line between input and optional negate
	                 //  1 -- not gate or vertical line
	                 //  2 -- vertical line between optional negate and calc value
	                 //  3 -- vertical line between calc value and full adder
	 
   public BinaryAdd()
   {
      super();

      int i, j; 
      long mask;

      mask = 0xFF;
      enableEvents( mask);

      setTitle("BinaryAdder - CPSC lab 231");
      AValues = new TextField[3]; // Decimal, Hex and Binary
      BValues = new TextField[3]; // Decimal, Hex and Binary
      SumValues = new TextField[3]; // Decimal, Hex and Binary

      for (i = 0; i < 3; i++)
      {
         AValues[i] = new TextField("0", 5);
         BValues[i] = new TextField("0", 5);
         SumValues[i] = new TextField("0", 5);
         SumValues[i].setEditable(false);
 
         AValues[i].addActionListener(this); 
         BValues[i].addActionListener(this); 
         SumValues[i].addActionListener(this); 

      }

      bitALabel = new Label[NUM_BITS];
      bitBLabel = new Label[NUM_BITS];
      bitSumLabel = new Label[NUM_BITS];
      carryOutLabel = new Label[NUM_BITS];
      inputBit_A_ValueTextField = new TextField[NUM_BITS];
      inputBit_B_ValueTextField = new TextField[NUM_BITS];
  
      calcBit_A_ValueTextField = new TextField[NUM_BITS];
      calcBit_B_ValueTextField = new TextField[NUM_BITS];
      resultBit_Sum_ValueTextField = new TextField[NUM_BITS];
      N_FlagTextField = new TextField("0", 1);
      Z_FlagTextField = new TextField("0", 1);
      V_FlagTextField = new TextField("0", 1);
      C_FlagTextField = new TextField("0", 1);

      N_FlagTextField.setEditable(false);
      Z_FlagTextField.setEditable(false);
      V_FlagTextField.setEditable(false);
      C_FlagTextField.setEditable(false);


      carryOutTextField = new TextField[NUM_BITS];
      carryInTextField = new TextField(1);
      carryInArrow = new ArrowCanvas[NUM_BITS];
      carryOutArrow = new ArrowCanvas[NUM_BITS];

      fullAdder = new FullAdderCanvas[NUM_BITS];
      A_inputPathCanvas = new GateCanvas[NUM_BITS][4]; 
      B_inputPathCanvas = new GateCanvas[NUM_BITS][4];
      Sum_outputPathCanvas = new GateCanvas[NUM_BITS];
 
      for (i = 0; i < NUM_BITS; i++)
      {
         for (j = 0; j < 4; j++)
         {
                             //  Always draw vertical line for A_path
            A_inputPathCanvas[i][j] = new GateCanvas(0); 

               // should draw invertor in B_path for division
            if (1 == j)   B_inputPathCanvas[i][j] = new GateCanvas(1);
            else B_inputPathCanvas[i][j] = new GateCanvas(0);
         } 
      }
      setSize(920, 780);
      setLocation(80, 80);

      fillInFrame();
      updateValues();
   }  // end constructor for BinaryAdd

   public void processWindowEvent(WindowEvent e)
   {
      if (e.getID() == WindowEvent.WINDOW_CLOSING)
      {
         dispose();
         System.exit(0);
      }
      else
      {
         super.processWindowEvent(e);
      }
   }

  public void itemStateChanged(ItemEvent e)
  {
     Checkbox source;

     if (e.getItemSelectable() instanceof Checkbox)
     {
        source = (Checkbox)e.getItemSelectable();
        if (source.equals(addCheckbox) && (ADDITION != currentOperation) )
        {
           currentOperation = ADDITION;
           updateValues();
           return;
        }
        if (source.equals(subtractCheckbox) && 
                           (SUBTRACTION != currentOperation) )
        {
           currentOperation = SUBTRACTION;
           updateValues();
           return;
        }

        if (source.equals(signedCheckbox) && 
                           (SIGNED != numberType) )
        {
           numberType = SIGNED;
           if (ValueA > 7) ValueA = ValueA - 16;
           if (ValueB > 7) ValueB = ValueB - 16;
           updateValues();
           return;
        }
        if (source.equals(unsignedCheckbox) && 
                           (UNSIGNED != numberType) )
        {
           numberType = UNSIGNED;
           if (ValueA < 0) ValueA = 16 + ValueA;
           if (ValueB < 0) ValueB = 16 + ValueB;
           updateValues();
           return;
        }

     } // endif  -- A checkbox state was changed
     else
     {
         System.out.println("A checkbox was NOT the source");
     }
  } // end itemStateChanged()

  public void actionPerformed(ActionEvent event)
  {
      String command;
      int i, j;
      int temp;
      boolean badInput = false;
      boolean AisSource;

      if (event.getSource() instanceof TextComponent)
      {
         TextComponent source = (TextComponent)event.getSource();
         AisSource = true;

         for (i = 0; i < 3; i++)
         {
             if (AValues[i].equals(source))
             {
                AisSource = true;
                break;
             }
             if (BValues[i].equals(source))
             {
                AisSource = false;
                break;
             }
         } // endfor
         if (3 == i) { /* Then there is an error */ }            
             
         int sourceBase = 0;
         if (0 == i) sourceBase = 10;
         if (1 == i) sourceBase = 16;
         if (2 == i) sourceBase = 2;
         try {
            if (AisSource)
            {
                temp = Integer.parseInt(AValues[i].getText(), sourceBase);
            }
            else
            {
                temp = Integer.parseInt(BValues[i].getText(), sourceBase);
            }
            if (( 10 !=sourceBase) && (SIGNED == numberType) && (temp > 7) )
            {
               temp = temp - 16;
            }
         } // end try
         catch (Exception e) { 
            badInput = true;
            temp = 0;
         }
         
         if (UNSIGNED == numberType) 
         {
            if ((temp < 0) || (temp > 15) ) badInput = true;
            // Show also put up a dialog box
         }
         else // numberType is Signed
         {
            if ((temp < -8) || (temp > 7) ) badInput = true;
         }
         if (!badInput)
         {  
            if (AisSource) ValueA = temp;
            else ValueB = temp;
         }
         updateValues();
      }
  }
  

   public void updateValues()
   {
      int i;
      int base = 10, mask;
      int bitValue;
      int ABitValue, BBitValue, carryBit;
      int sum, carry, value;
      FullAdder myFullAdder = new FullAdder();
      boolean invert;
      String zeroString = new String("0");
      String oneString = new String("1");
      String ABitString, BBitString, SumBitString, carryInString;
      String bitString[] = new String[2];

      bitString[0] = zeroString;
      bitString[1] = oneString;
      /*
      if (UNSIGNED == numberType)
      {
         if (ValueA < 0) ValueA = 16 + ValueA;
         if (ValueB < 0) ValueB = 16 + ValueB;
      }
      else
      {
         if (ValueA > 7) ValueA = ValueA - 16;
         if (ValueB > 7) ValueB = ValueB - 16;
      }
*/
      if (ADDITION == currentOperation) ValueSum = ValueA + ValueB;
      else ValueSum = ValueA - ValueB;
      if (UNSIGNED == numberType)
      {
          if (ValueSum < 0) ValueSum = 16 + ValueSum;
          if (ValueSum > 15) ValueSum %= 16;
      }
      else // numberType is SIGNED
      {
          while (ValueSum < -8) ValueSum = 16 + ValueSum;
          while (ValueSum > 7) ValueSum = ValueSum - 16;
      }

      for (i = 0; i < 3; i++)
      {
         if (0 == i) base = 10;
         if (1 == i) base = 16;
         if (2 == i) base = 2;

         if ((i > 0) && (ValueA < 0)) value = 16 + ValueA;
         else value = ValueA;
         AValues[i].setText(Integer.toString(value, base));

         if ((i > 0) && (ValueB < 0)) value = 16 + ValueB;
         else value = ValueB;
         BValues[i].setText(Integer.toString(value, base));

         if ((i > 0) && (ValueSum < 0)) value = 16 + ValueSum;
         else value = ValueSum;
         SumValues[i].setText(Integer.toString(value, base));
      }
      if  (SUBTRACTION == currentOperation)
      {
         invert = true;
         carryInTextField.setText(oneString);
      }
      else
      {
         invert = false;
         carryInTextField.setText(zeroString);
      }
      for (i = 0, mask = 1; i < NUM_BITS; i++, mask = mask << 1)
      {
         if (0 == (mask & ValueA)) bitValue = 0;
         else bitValue = 1;
         inputBit_A_ValueTextField[i].setText(bitString[bitValue]);
         calcBit_A_ValueTextField[i].setText(bitString[bitValue]);
         ABitValue = bitValue;

         if (0 == (mask & ValueB)) bitValue = 0;
         else bitValue = 1;
         inputBit_B_ValueTextField[i].setText(bitString[bitValue]);

         if (SUBTRACTION == currentOperation) bitValue = 1 - bitValue;

         calcBit_B_ValueTextField[i].setText(bitString[bitValue]);
         BBitValue = bitValue;

         if ( 0 == i) carryInString = carryInTextField.getText();
         else carryInString = carryOutTextField[i - 1].getText();

         if (carryInString.equals("0") ) carryBit = 0;
         else carryBit = 1;
         sum = myFullAdder.evaluate(ABitValue, BBitValue, carryBit);
         carry = myFullAdder.getCarry();

         resultBit_Sum_ValueTextField[i].setText(bitString[sum]);
         carryOutTextField[i].setText(bitString[carry]);

         B_inputPathCanvas[i][1].setInverted(invert);
      }  // endFor i
      if (0 == (15 & ValueSum) ) Z_FlagTextField.setText("1");
      else Z_FlagTextField.setText("0");

      if (carryOutTextField[NUM_BITS - 1].getText().equals(oneString)
          == (ADDITION == currentOperation))
           C_FlagTextField.setText(oneString);
      else C_FlagTextField.setText(zeroString);

      ABitString = calcBit_A_ValueTextField[NUM_BITS - 1].getText();
      BBitString = calcBit_B_ValueTextField[NUM_BITS - 1].getText();
      SumBitString = resultBit_Sum_ValueTextField[NUM_BITS - 1].getText();

      if (ABitString.equals(BBitString) && !(ABitString.equals(SumBitString)) )
           V_FlagTextField.setText(oneString);
      else V_FlagTextField.setText(zeroString);

      if (SumBitString.equals(oneString)) N_FlagTextField.setText(oneString);
      else  N_FlagTextField.setText(zeroString); 
      repaint();
   }  // end -- updateValues()

   public void fillInFrame()
   {
      GraphPaperLayout layout = new GraphPaperLayout(new Dimension(36, 24) );
      GridBagConstraints c = new GridBagConstraints();
      int i;

      setLayout(layout);
      add(new Label("Operations"), new Rectangle(1, 1, 3, 1) );
      cbg_op = new CheckboxGroup();
      addCheckbox = new Checkbox("Addition", cbg_op, true);
      subtractCheckbox = new Checkbox("Subtraction", cbg_op, false);
      addCheckbox.addItemListener(this);
      subtractCheckbox.addItemListener(this);
      add(addCheckbox, new Rectangle(1, 2, 4, 1) );
      add(subtractCheckbox, new Rectangle(1, 3, 4, 1) );

      add(new Label("Numeric Format"), new Rectangle(1, 5, 4, 1) );
      numberTypeCBG = new CheckboxGroup();
      unsignedCheckbox = new Checkbox("Unsigned", numberTypeCBG, true);
      signedCheckbox = new Checkbox("Signed", numberTypeCBG, false);
      unsignedCheckbox.addItemListener(this);
      signedCheckbox.addItemListener(this);
      add(unsignedCheckbox, new Rectangle(1, 6, 3, 1) );
      add(signedCheckbox, new Rectangle(1, 7, 3, 1) );


      add(new Label("Decimal"), new Rectangle(7, 1, 3, 1) );     
      add(new Label("Hex"), new Rectangle(13, 1, 2, 1) );     
      add(new Label("Binary"), new Rectangle(17, 1, 3, 1) );     

      add (new Label("A"), new Rectangle(6, 2, 1 , 1) );
      add (new Label("B"), new Rectangle(6, 4, 1 , 1) );
      add (new Label("Sum"), new Rectangle(5, 6, 2 , 1) );

      for (i = 0; i < 3; i++)
      {
          add(AValues[i], new Rectangle(7 + i * 5, 2, 4, 1) );
          add(BValues[i], new Rectangle(7 + i * 5, 4, 4, 1) );
          add(SumValues[i], new Rectangle(7 + i * 5, 6, 4, 1) );

      }

      add (new Label("Flags"), new Rectangle(22, 1, 2, 1) );
      add (new Label("N"), new Rectangle(22, 2, 1, 1) );
      add (N_FlagTextField, new Rectangle( 22, 3, 1, 1) );

      add (new Label("Z"), new Rectangle(25, 2, 1, 1) );
      add (Z_FlagTextField, new Rectangle( 25, 3, 1, 1) );

      add (new Label("V"), new Rectangle(28, 2, 1, 1) );
      add (V_FlagTextField, new Rectangle( 28, 3, 1, 1) );

      add (new Label("C"), new Rectangle(31, 2, 1, 1) );
      add (C_FlagTextField, new Rectangle( 31, 3, 1, 1) );

      c.gridwidth = 1;
      c.gridheight = 1;
      for (i = 0; i < NUM_BITS; i++)
      {
         bitALabel[i] = new Label("A" + i);
         bitBLabel[i] = new Label("B" + i);
         bitSumLabel[i] = new Label("S" + i);

         c.gridx = LEFT + (3 - i) * 8 + 5;
         c.gridy = TOP + 8;
         add(bitALabel[i], new Rectangle(5 + (3 - i) * 8, 8, 1, 1 ) );

         c.gridx = LEFT + (3 - i) * 8 + 7;
         c.gridy = TOP + 8;
         add(bitBLabel[i], new Rectangle(7 + (3 - i) * 8, 8, 1, 1) );

         inputBit_A_ValueTextField[i] = new TextField(1);
         inputBit_A_ValueTextField[i].setEditable(false);

         inputBit_B_ValueTextField[i] = new TextField(1);
         inputBit_B_ValueTextField[i].setEditable(false);

         c.gridx = LEFT + (3 - i) * 8 + 5;
         c.gridy = TOP + 9;
         add(inputBit_A_ValueTextField[i],
                  new Rectangle(5 + (3 - i) * 8, 9, 1, 1 ) );
if ( i > -1)
 {
         c.gridx = LEFT + (3 - i) * 8 + 7;
         c.gridy = TOP + 9;
         add(inputBit_B_ValueTextField[i],
                  new Rectangle(7 + (3 - i) * 8, 9, 1, 1 ) );
 }

         c.gridx = LEFT + (3 - i) * 8 + 5;
         c.gridy = TOP + 10;
         add(A_inputPathCanvas[i][0], 
                  new Rectangle(5 + (3 - i) * 8, 10, 1, 1 ) );

         c.gridx = LEFT + (3 - i) * 8 + 5;
         c.gridy = TOP + 11;

         add(A_inputPathCanvas[i][1],
                   new Rectangle(5 + (3 - i) * 8, 11, 1, 1 ) );

         c.gridx = LEFT + (3 - i) * 8 + 5;
         c.gridy = TOP + 12;
         add(A_inputPathCanvas[i][2],
                   new Rectangle(5 + (3 - i) * 8, 12, 1, 1 ) );

         c.gridx = LEFT + (3 - i) * 8 + 5;
         c.gridy = TOP + 14;
         add(A_inputPathCanvas[i][3],
                   new Rectangle(5 + (3 - i) * 8, 14, 1, 1 ) );

         c.gridx = LEFT + (3 - i) * 8 + 7;
         c.gridy = TOP + 10;
         add(B_inputPathCanvas[i][0],
                   new Rectangle(7 + (3 - i) * 8, 10, 1, 1 ) );

         c.gridx = LEFT + (3 - i) * 8 + 7;
         c.gridy = TOP + 11;
         add(B_inputPathCanvas[i][1],
                   new Rectangle(7 + (3 - i) * 8, 11, 1, 1 ) );

         c.gridx = LEFT + (3 - i) * 8 + 7;
         c.gridy = TOP + 12;
         add(B_inputPathCanvas[i][2],
                   new Rectangle(7 + (3 - i) * 8, 12, 1, 1 ) );

         c.gridx = LEFT + (3 - i) * 8 + 7;
         c.gridy = TOP + 14;
         add(B_inputPathCanvas[i][3],
                   new Rectangle(7 + (3 - i) * 8, 14, 1, 1 ) );

         c.gridx = LEFT + (3 - i) * 8 + 6;
         c.gridy = TOP + 20;
         add(bitSumLabel[i],
                   new Rectangle(6 + (3 - i) * 8, 20, 1, 1 ) );

         calcBit_A_ValueTextField[i] = new TextField(1);
         calcBit_A_ValueTextField[i].setEditable(false);
         calcBit_B_ValueTextField[i] = new TextField(1);
         calcBit_B_ValueTextField[i].setEditable(false);


         carryOutTextField[i] = new TextField(1);
         carryOutTextField[i].setEditable(false); 

         c.gridx = LEFT + (3 - i) * 8 + 5;
         c.gridy = TOP + 13;
if (i> -1)
 {
         add(calcBit_A_ValueTextField[i],
                   new Rectangle(5 + (3 - i) * 8, 13, 1, 1 ) );
 }
if ( i > -1)
 {
         c.gridx = LEFT + (3 - i) * 8 + 7;
         c.gridy = TOP + 13;
         add(calcBit_B_ValueTextField[i],
                   new Rectangle(7 + (3 - i) * 8, 13, 1, 1 ) );
 }

         resultBit_Sum_ValueTextField[i] = new TextField(1);
         resultBit_Sum_ValueTextField[i].setEditable(false);

         c.gridx = LEFT + (3 - i) * 8 + 6;
         c.gridy = TOP + 19;
         add(resultBit_Sum_ValueTextField[i],
                   new Rectangle(6 + (3 - i) * 8, 19, 1, 1 ) );

         fullAdder[i] = new FullAdderCanvas();
         c.gridx = LEFT + (3 - i) * 8 + 3;
         c.gridy = TOP + 15;
         c.gridwidth = 5;
         c.gridheight = 3;
         add(fullAdder[i],
                   new Rectangle(4 + (3 - i) * 8, 15, 5, 3 ) );

         c.gridwidth = 1;
         c.gridheight = 1;

         c.gridx = LEFT + (3 - i) * 8 + 1;
         c.gridy = TOP + 16;
         add(carryOutTextField[i],
                   new Rectangle(2 + (3 - i) * 8, 16, 1, 1 ) );

         if (NUM_BITS - 1 != i) carryOutLabel[i] = new Label("  Carry");
         else carryOutLabel[i] = new Label("Carry Out");

         add(carryOutLabel[i],
                   new Rectangle(1 + (3 - i) * 8, 17, 3, 1 ) );

         carryOutArrow[i] = new ArrowCanvas();

         add(carryOutArrow[i],
                   new Rectangle(3 + (3 - i) * 8, 16, 1, 1 ) );

         carryInArrow[i] = new ArrowCanvas();

         add(carryInArrow[i],
                   new Rectangle(9 + (3 - i) * 8, 16, 1, 1 ) );
         Sum_outputPathCanvas[i] = new GateCanvas(0);
         add(Sum_outputPathCanvas[i], new Rectangle(6 + (3 - i) * 8, 18, 1, 1) );
       
      } // end for - i
      carryInTextField.setEditable(false); 
      add(carryInTextField, new Rectangle(2 + 4 * 8, 16, 1, 1 ) );
      add(new Label("Carry In"), new Rectangle(2 + 4 * 8, 17, 3, 1 ) );
    
       

      Canvas DummyCanvas[] = new Canvas[10];
      for (i = 0; i < 10; i++)
      {
         DummyCanvas[i] = new Canvas();
      }
      c.gridx = 0;
      c.gridy = TOP + 15;
      DummyCanvas[0].setSize(1, 30);
      //   layout.setConstraints(DummyCanvas[0], c);

      c.gridy = TOP + 18;
      DummyCanvas[1].setSize(10, 10);
      //   layout.setConstraints(DummyCanvas[1], c);

   } // End FillInframe()

   public static void main(String args[])
   {
      BinaryAdd localFrame = new BinaryAdd();

      // localFrame.fillInFrame();

      localFrame.setVisible(true);
      localFrame.addNotify();
   }  /* end main */


} // End class BinaryAdd
