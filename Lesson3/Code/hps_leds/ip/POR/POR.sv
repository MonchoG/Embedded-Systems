// POR.sv
// ////////////////////////////////////////////////
//   Simple Power On Reset module
// ////////////////////////////////////////////////
// (c) A.L.S.E.
// Version : 2013.11.06
// Author  : Bert Cuzeau
// E_mail  : info@alse-fr.com
// Web     : http://www.alse-fr.com
//
// DISCLAIMER : NEITHER THE WHOLE NOR ANY PART OF THE INFORMATION CONTAINED IN,
// MAY BE ADAPTED OR REPRODUCED IN ANY MATERIAL OR ELECTRONIC FORM WITHOUT THE
// PRIOR WRITTEN CONSENT OF THE COPYRIGHT HOLDER.
// THE INFORMATION, DOCUMENTATION AND CODE ARE SUPPLIED ON AN AS-IS BASIS AND
// NO WARRANTY AS TO THEIR SUITABILITY FOR ANY PARTICULAR PURPOSE IS EITHER
// MADE OR IMPLIED.
// ALSE WILL NOT ACCEPT ANY CLAIM FOR DAMAGES HOWSOEVER ARISING AS A RESULT OF USE
// OF ANY INFORMATION PROVIDED.
//
//


module POR (
  input   wire  clk       ,
  input   wire  reset_n   ,
  output  reg   por_out
);


  logic [ 3:0] rst_cnt = 'b0000; // for simulation only


  always @(posedge clk or negedge reset_n) 
  begin
    if (reset_n == 1'b0) begin
      rst_cnt   <= 'b0000;
    end else begin
      //
      if (rst_cnt == 4'b1010) begin
        por_out <= 1'b0;            // release the Reset
      end else begin
        por_out <= 1'b1;            // force the internal reset
        rst_cnt <= rst_cnt + 1'b1;  // count up to "1010"
      end
    end
  end
  

endmodule
