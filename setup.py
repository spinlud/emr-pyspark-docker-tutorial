from setuptools import setup

setup(
    name='emr_pyspark_docker_tutorial',
    version='1.0.0',
    author='Ludovico Fabbri',
    author_email='ludovico.fabbri@gmail.com',
    description='EMR Spark tutorial source code',
    url='https://github.com/spinlud/emr-spark-tutorial',
    package_dir={
        '': 'src'
    },
    packages=[
        'my_spark_app',
        'my_spark_app.shared',
    ],
    classifiers=[
        'Intended Audience :: Developers',
        'Programming Language :: Python',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
    python_requires='>=3.8',
)
