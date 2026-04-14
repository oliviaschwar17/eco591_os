# 07 Interpretation #

### Olivia Schwartz ###

1. **Justify filtering choices**

First, I removed indels with (--remove-indels), which are the variants that alters the length of the
reference allele. Then, I used --max-missing-count 1, which excluded
sites with greater than 1 missing genotype across all individuals. With
2 individuals this needed to be low. Next, I used --mac 2, to include
sites greater than or equal to the Minor Allele Count value, which isthe
number of times an allele appears across all individuals. As there were
only 2 individuals, 2 was a pretty strict value for this dataset. After
that, I ran --minQ 40, which only kept sites with a quality score
greater than 40. For the penultimate step I used--minDP 5 because
min-meanDP wasn't working for me, so I substituted here. The minDP
setting includes genotypes greater than or equal to 5, using the DP
format tag. Finally I used --thin 2, to make sure the sites weren't
adjacent to each other to lower chances of capturing sites with similar
qualities.

2. **Summary statistic: interpret output, decide if sensible**

The parameter --hardy produces p-value for each site from a Hardy-Weinberg Equilibrium, as
well as Observed numbers of Homozygotes and Heterozygotes and the
matching Expected values under HWE. Since I TA for Evolution, I thought
this would be an interesting statistic to observe in an actual dataset.
From my output (07_out.hwe), it looks like majority of the individuals
were heterozygous at the 32 remaining sites after filtering parameters.
Every site was expected to be at a 1:2:1 ratio in HWE. From what I can
tell, it looks like every p-value created was not significant at all,
with the smallest value being 0.333.


**Sites remaining at each step:** 
- Step 0: 397
- Step 1: 378
- Step 2: 377
- Step 3: 34
- Step 4: 34
- Step 5: 34
- Step 6: 32

