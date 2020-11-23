import os


class Config:
	READ_PROTOCOL = os.environ['READ_PROTOCOL'] if 'READ_PROTOCOL' in os.environ else 's3'
	WRITE_PROTOCOL = os.environ['WRITE_PROTOCOL'] if 'WRITE_PROTOCOL' in os.environ else 'hdfs'
