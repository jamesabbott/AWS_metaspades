# MetaSPAdES resource requirement assessment

## The data

The data for this assessment is already in the public domain, and is available
from the European Nucleotide Archive. The `download_data.sh` script should
automate this process, and retrieve the data from ENA via ftp, storing the
results in a `fastq` directory. The script also saves the files with a
meaningful sample name in place of the database accession to make merging the
samples easier.

I've included a file of md5sums if you want to check the file integrity. 

The data consists of 12 samples from 3 environments, named Bulk, Desert, North
and Elite. The 'Bulk' samples are unplanted soil controls, while the other three
groups are different barley genotypes. There are two fastq format files for each
sample (so 24 files in total), which are distinguished with `_1` and `_2` in the
sample naming. If you aren't familiar with these datatypes, the fastq format
uses 4 lines to store data from each independent sequence read. Each group of
four lines contains:

1.  Unique Read-id, with the line starting with an '@' character 
2.  The read sequence as a string of ATCG
3.  Normally just a '+' symbol, but may also duplicate the read id
4.  Base quality scores indicating a log-likelihood the call for each base of
	the sequence is correct. These scores range from 0-40 and are encoded as
	ASCII characters, with the actual score being found by subtracting 33 from
	ASCII value of the character

The fastq files will be gzipped, and do not require decompressing since most
tools will work with the compressed data by default.

## Batching Data

MetaSpades will only process a single library (i.e. pair of fastq files) at a time, so it is necessary to concatenate these into whichever combinations are to be run. 

i.e. to batch together all the Bulk1 samples

```
cat Bulk1_1.fastq.gz Bulk2_1.fastq.gz Bulk3_1.fastq.gz > Bulk_all_1.fastq.gz
cat Bulk1_2.fastq.gz Bulk2_2.fastq.gz Bulk3_2.fastq.gz > Bulk_all_2.fastq.gz
```

The reads in the two fastq files for a sample i.e. `Bulk_1.fastq.gz` and
`Bulk_2.fastq.gz` represent sequence reads from opposite ends of the same DNA
fragment, and must occur in the same order in each file, since they are
processed in order. For this reason, it is essential that the filenames for the
_1 and _2 files are provided in the same order to ensure the pairing
information in the data is correctly retainined.

It might be worth starting with a single sample, then scaling up to the three samples of a group (i.e. all Elite), then two groups together and finally all the data combined. 

## The MetaSPAdes Assembler

Metaspades is provided as part of the SPAdes assembly package: [https://github.com/ablab/spades](https://github.com/ablab/spades). This is also available from the bioconda channel, so can be installed with:

```
conda install -c bioconda spades
```

It's usage is very simple, just requiring the path to the `_1` and `_2` fastq
files, and the path to an output directory (which it will create itself) i.e.

`metaspades.py -t [num_threads] -1 Bulk_all.1.fastq.gz -2 Bulk_all.2.fastq.gz -o outputs`

By default spades has a memory limit of 250Gb and uses this to decide how to
size various buffers. If going above 250Gb this should be increased accordingly
i.e. `-m 384` to specify a 384 Gb memory limit.

## Previous Benchmarks

I've been able to find the runtime details of the assembly of each of the 12
samples independently, but not when all three samples of a group were pooled.

These were run using 16 threads, and recorded a maxvmem range for the 12 samples
of between 91-150Gb, with walltimes of 6300-76180s and cpu times of
92100-669300s. I can't actually access the nodes which ran the jobs at the
moment so can't tell you want kind of CPU these used, but may be able to get
that information in due course. 

Note that the composition of the bulk soil samples will differ considerably from
that of the planted soils, so these will be expected to behave differently. 