import os

from setuptools import (
    find_namespace_packages, setup)

if __name__ == '__main__':
    package_name = os.getenv('PACKAGE_NAME', 'demo')
    setup(
        name=package_name,
        version='0.0.dev0',
        package_dir={'': 'src'},
        packages=find_namespace_packages('src', include=[
            f'{package_name}*'
        ]),
        install_requires=[],
        entry_points={
            'console_scripts': [
                'fibo=demo.main:main'
            ]
        }
        # data_files=[
        #     ('cfg', ['cfg/model_definitions.json'])
        # ]
    )
