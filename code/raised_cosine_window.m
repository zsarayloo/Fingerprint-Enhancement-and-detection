function w = raised_cosine_window(block_sz,over_lp)
y = raised_cosine(block_sz,over_lp);
w = y(:)*y(:)';