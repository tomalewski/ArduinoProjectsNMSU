extern "C" { void testf(); } 
void setup() { 
  testf();
   } 

void loop() {
  // put your main code here, to run repeatedly:
  
}

fl_line(a1.x, a1.y, b1.x, b1.y);
         fl_line(b2.x, b2.y, c1.x, c1.y);
         fl_line(c2.x, c2.y, d1.x, d1.y);
         fl_line(d2.x, d2.y, a2.x, a2.y);

         fl_arc(origin.x, origin.y, radius + radius, radius + radius, 90, 180);
         fl_arc(origin.x + width - (radius + radius), origin.y, radius + radius, radius + radius, 360, 90);
         fl_arc(origin.x + width - (radius + radius), origin.y + height - (radius + radius), radius + radius, radius + radius, 270, 360);
         fl_arc(origin.x, origin.y + height - (radius + radius), radius + radius, radius + radius, 180, 270);
