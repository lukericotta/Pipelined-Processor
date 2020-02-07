module sra (Shift_Out, Shift_In, Shift_Val);
	input [15:0] Shift_In;
	input [15:0] Shift_Val;
	output [15:0] Shift_Out;
	
	assign Shift_Out = (Shift_Val == 0 ? (Shift_In):
							(Shift_Val == 1 ? (Shift_In >>> 1):
								(Shift_Val == 2 ? (Shift_In >>> 2):
									(Shift_Val == 3 ? (Shift_In >>> 3):
										(Shift_Val == 4 ? (Shift_In >>> 4):
											(Shift_Val == 5 ? (Shift_In >>> 5):
												(Shift_Val == 6 ? (Shift_In >>> 6):
													(Shift_Val == 7 ? (Shift_In >>> 7):
														(Shift_Val == 8 ? (Shift_In >>> 8):
															(Shift_Val == 9 ? (Shift_In >>> 9):
																(Shift_Val == 10 ? (Shift_In >>> 10):
																	(Shift_Val == 11 ? (Shift_In >>> 11):
																		(Shift_Val == 12 ? (Shift_In >>> 12):
																			(Shift_Val == 13 ? (Shift_In >>> 13):
																				(Shift_Val == 14 ? (Shift_In >>> 14):
																					(Shift_Val == 15 ? (Shift_In >>> 15):
																						(Shift_In[15] ? (16'hFFFF) : (16'h0000))))))))))))))))));
	
	
	
	
endmodule
