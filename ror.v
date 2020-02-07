module ror (Rotate_Out, Rotate_In, Rotate_Val);
	input [15:0] Rotate_In;
	input [15:0] Rotate_Val;
	output [15:0] Rotate_Out;
	
	
	assign Rotate_Out = (Rotate_Val == 0 ? (Rotate_In):
							(Rotate_Val == 1 ? ({Rotate_In[0],Rotate_In[15:1]}):
								(Rotate_Val == 2 ? ({Rotate_In[1:0],Rotate_In[15:2]}):
									(Rotate_Val == 3 ? ({Rotate_In[2:0],Rotate_In[15:3]}):
										(Rotate_Val == 4 ? ({Rotate_In[3:0],Rotate_In[15:4]}):
											(Rotate_Val == 5 ? ({Rotate_In[4:0],Rotate_In[15:5]}):
												(Rotate_Val == 6 ? ({Rotate_In[5:0],Rotate_In[15:6]}):
													(Rotate_Val == 7 ? ({Rotate_In[6:0],Rotate_In[15:7]}):
														(Rotate_Val == 8 ? ({Rotate_In[7:0],Rotate_In[15:8]}):
															(Rotate_Val == 9 ? ({Rotate_In[8:0],Rotate_In[15:9]}):
																(Rotate_Val == 10 ? ({Rotate_In[9:0],Rotate_In[15:10]}):
																	(Rotate_Val == 11 ? ({Rotate_In[10:0],Rotate_In[15:11]}):
																		(Rotate_Val == 12 ? ({Rotate_In[11:0],Rotate_In[15:12]}):
																			(Rotate_Val == 13 ? ({Rotate_In[12:0],Rotate_In[15:13]}):
																				(Rotate_Val == 14 ? ({Rotate_In[13:0],Rotate_In[15:14]}):
																					(Rotate_Val == 15 ? ({Rotate_In[14:0],Rotate_In[15]}):
																						(Rotate_Val == 16 ? (Rotate_In):
																							(16'h0000))))))))))))))))));
	
	
	
	
	
endmodule
