## N-mixture model

This is another widely used model among ecologists to estimate distribution of species when accounting for false negatives. By [MacKenzie et al. 2002](https://esajournals.onlinelibrary.wiley.com/doi/full/10.1890/0012-9658%282002%29083%5B2248%3AESORWD%5D2.0.CO%3B2)

We implemented a simpler version here, where there are R sites and each site is sampled T repeats, the data y_{it} are binary detections. The model is there is a latent z_i~Ber(psi) and y_{it}~Ber(p*z_i) independent, the goal is to estimate p and psi. (It's a rather fat banana...)

![](https://raw.githubusercontent.com/YunyiShen/weird-posteriors/master/banana/occupancy/p_psi.png)
