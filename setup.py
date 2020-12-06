import os

from setuptools import (
    find_namespace_packages, setup)

if __name__ == '__main__':
    setup(
        name='demo',
        version=os.getenv('PACKAGE_VERSION', '0.0.dev0'),
        author='Stefan Schenk',
        author_email='stefan_schenk@hotmail.com',
        description='Just a packaging example project.',
        package_dir={'': 'src'},
        packages=find_namespace_packages('src', include=[
            'demo*'
        ]),
        install_requires=[],
        entry_points={
            'console_scripts': [
                'fibo=demo.main:cli'
            ]
        },
        data_files=[
            ('data', ['data/text.txt'])
        ]
    )
