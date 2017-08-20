# Modify the following settings to configure the miner:

# The WhatToMine URL relevant to your rig (e.g., "https://whattomine.com/coins?utf8=%E2%9C%93&eth=true&factor%5Beth_hr%5D=70.0&factor%5Beth_p%5D=280.0&grof=true&factor%5Bgro_hr%5D=138.0&factor%5Bgro_p%5D=590&x11gf=true&factor%5Bx11g_hr%5D=46.56&factor%5Bx11g_p%5D=590&cn=true&factor%5Bcn_hr%5D=1660.0&factor%5Bcn_p%5D=280.0&eq=true&factor%5Beq_hr%5D=1600.0&factor%5Beq_p%5D=570&lre=true&factor%5Blrev2_hr%5D=139000.0&factor%5Blrev2_p%5D=550&ns=true&factor%5Bns_hr%5D=2950.0&factor%5Bns_p%5D=590&lbry=true&factor%5Blbry_hr%5D=1070.0&factor%5Blbry_p%5D=590&bk2bf=true&factor%5Bbk2b_hr%5D=5500.0&factor%5Bbk2b_p%5D=380.0&bk14=true&factor%5Bbk14_hr%5D=12000.0&factor%5Bbk14_p%5D=420.0&pas=true&factor%5Bpas_hr%5D=3400.0&factor%5Bpas_p%5D=420.0&bkv=true&factor%5Bbkv_hr%5D=0.0&factor%5Bbkv_p%5D=0.0&factor%5Bcost%5D=0.16&sort=Profit&volume=0&revenue=current&factor%5Bexchanges%5D%5B%5D=&factor%5Bexchanges%5D%5B%5D=bittrex&factor%5Bexchanges%5D%5B%5D=bleutrade&factor%5Bexchanges%5D%5B%5D=btc_e&factor%5Bexchanges%5D%5B%5D=bter&factor%5Bexchanges%5D%5B%5D=c_cex&factor%5Bexchanges%5D%5B%5D=cryptopia&factor%5Bexchanges%5D%5B%5D=poloniex&factor%5Bexchanges%5D%5B%5D=yobit&dataset=Main&commit=Calculate&adapt_q_280x=0&adapt_q_380=0&adapt_q_fury=0&adapt_q_470=0&adapt_q_480=0&adapt_q_750Ti=0&adapt_q_10606=0&adapt_q_1070=0&adapt_q_1080=0&adapt_q_1080Ti=2")
whattomine.url = "https://whattomine.com/coins?utf8=%E2%9C%93&eth=true&factor%5Beth_hr%5D=70.0&factor%5Beth_p%5D=280.0&grof=true&factor%5Bgro_hr%5D=138.0&factor%5Bgro_p%5D=590&x11gf=true&factor%5Bx11g_hr%5D=46.56&factor%5Bx11g_p%5D=590&cn=true&factor%5Bcn_hr%5D=1660.0&factor%5Bcn_p%5D=280.0&eq=true&factor%5Beq_hr%5D=1600.0&factor%5Beq_p%5D=570&lre=true&factor%5Blrev2_hr%5D=139000.0&factor%5Blrev2_p%5D=550&ns=true&factor%5Bns_hr%5D=2950.0&factor%5Bns_p%5D=590&lbry=true&factor%5Blbry_hr%5D=1070.0&factor%5Blbry_p%5D=590&bk2bf=true&factor%5Bbk2b_hr%5D=5500.0&factor%5Bbk2b_p%5D=380.0&bk14=true&factor%5Bbk14_hr%5D=12000.0&factor%5Bbk14_p%5D=420.0&pas=true&factor%5Bpas_hr%5D=3400.0&factor%5Bpas_p%5D=420.0&bkv=true&factor%5Bbkv_hr%5D=0.0&factor%5Bbkv_p%5D=0.0&factor%5Bcost%5D=0.16&sort=Profit&volume=0&revenue=current&factor%5Bexchanges%5D%5B%5D=&factor%5Bexchanges%5D%5B%5D=bittrex&factor%5Bexchanges%5D%5B%5D=bleutrade&factor%5Bexchanges%5D%5B%5D=btc_e&factor%5Bexchanges%5D%5B%5D=bter&factor%5Bexchanges%5D%5B%5D=c_cex&factor%5Bexchanges%5D%5B%5D=cryptopia&factor%5Bexchanges%5D%5B%5D=poloniex&factor%5Bexchanges%5D%5B%5D=yobit&dataset=Main&commit=Calculate&adapt_q_280x=0&adapt_q_380=0&adapt_q_fury=0&adapt_q_470=0&adapt_q_480=0&adapt_q_750Ti=0&adapt_q_10606=0&adapt_q_1070=0&adapt_q_1080=0&adapt_q_1080Ti=2"

# If you plan to mine Signatum(SIGT), specify the WhatToMine Signatum URL (e.g., "https://whattomine.com/coins/191-sigt-skunkhash?utf8=%E2%9C%93&hr=105&p=580&fee=0.0&cost=0.16&hcost=0.0&commit=Calculate")
sigt.whattomine.url = "https://whattomine.com/coins/191-sigt-skunkhash?utf8=%E2%9C%93&hr=105&p=580&fee=0.0&cost=0.16&hcost=0.0&commit=Calculate"

# The power cost per day (in USD) for running your rig (e.g., 2.27 for 2x 1080Ti). These values can be obtained from WhatToMine
power.cost = 2.27

# Time (in seconds) to wait before updating WhatToMine statistics (minimum is 60)

update.stats.wait.time = 60

# Time (in seconds) to wait between recalculating hashrate statistics (minimum is 5)

refresh.time = 5

# If restart.if.gpu.not.detected is TRUE, the PC will be restarted if one or more of the GPUs are not detected by Windows.
# By default, this is set to FALSE
# This is useful when running an unsupervised dedicated mining rig which uses PCI-e risers.

restart.if.gpu.not.detected = FALSE

# If a GPU is using less than power.threshold.for.restart * maximum power, the miner will be restarted.
# E.g., a GTX 10080 Ti has a 300.00W power limit when overclocked. With power.threshold.for.restart = 0.3, if the GPU is consistently below 100.0W, the miner will be restarted.

power.threshold.for.restart = 0.3

# Set this to true if you want the miner to report stats on power usage, temperature etc.
# WARNING: This only works with NVIDIA GPUs.

stats.reporting = TRUE

# Make sure that this file is saved as .r