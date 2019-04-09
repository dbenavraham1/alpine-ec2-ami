# Alpine Linux EC2 AMI Build

**NOTE: This is not an official Amazon or AWS provided image.  This is
community built and supported.**

This repository contains a packer file and a script to create an EC2 AMI
containing Alpine Linux.  The AMI is designed to work with most EC2 features
such as Elastic Network Adapters and NVME EBS volumes by default.  If anything
is missing please report a bug.

This image can be launched on any modern x86_64 instance type, including T3,
M5, C5, I3, R5, P3, X1, X1e, D2, Z1d.  Other instances may also work but have
not been tested.  If you find an issue with instance support for any current
generation instance please file a bug against this project.

To get started use one of the AMIs below.  The default user is `alpine` and
will be configured to use whatever SSH keys you chose when you launched the
image.  If user data is specified it must be a shell script that begins with
`#!`.  If a script is provided it will be executed as root after the network is
configured.

**NOTE:** *We are working to automate AMI builds and updates to this file and
[release.yaml](https://github.com/mcrute/alpine-ec2-ami/blob/master/release.yaml)
in the not-too-distant future.*

| Alpine Release | Region Code | AMI ID |
| :------------: | ----------- | ------ |
| 3.9.3 | ap-northeast-1 | [ami-001e74131496d0212](https://ap-northeast-1.console.aws.amazon.com/ec2/home#launchAmi=ami-001e74131496d0212) |
| 3.9.3 | ap-northeast-2 | [ami-09a26b03424d75667](https://ap-northeast-2.console.aws.amazon.com/ec2/home#launchAmi=ami-09a26b03424d75667) |
| 3.9.3 | ap-south-1 | [ami-03534f64f8b87aafc](https://ap-south-1.console.aws.amazon.com/ec2/home#launchAmi=ami-03534f64f8b87aafc) |
| 3.9.3 | ap-southeast-1 | [ami-0d5f2950efcd55b0e](https://ap-southeast-1.console.aws.amazon.com/ec2/home#launchAmi=ami-0d5f2950efcd55b0e) |
| 3.9.3 | ap-southeast-2 | [ami-0660edcba4ba7c8a0](https://ap-southeast-2.console.aws.amazon.com/ec2/home#launchAmi=ami-0660edcba4ba7c8a0) |
| 3.9.3 | ca-central-1 | [ami-0bf4ea1f0f86283bb](https://ca-central-1.console.aws.amazon.com/ec2/home#launchAmi=ami-0bf4ea1f0f86283bb) |
| 3.9.3 | eu-central-1 | [ami-060d9bbde8d5047e8](https://eu-central-1.console.aws.amazon.com/ec2/home#launchAmi=ami-060d9bbde8d5047e8) |
| 3.9.3 | eu-north-1 | [ami-0a5284750fcf11d18](https://eu-north-1.console.aws.amazon.com/ec2/home#launchAmi=ami-0a5284750fcf11d18) |
| 3.9.3 | eu-west-1 | [ami-0af60b964eb2f09d3](https://eu-west-1.console.aws.amazon.com/ec2/home#launchAmi=ami-0af60b964eb2f09d3) |
| 3.9.3 | eu-west-2 | [ami-097405edd3790cf8b](https://eu-west-2.console.aws.amazon.com/ec2/home#launchAmi=ami-097405edd3790cf8b) |
| 3.9.3 | eu-west-3 | [ami-0078916a37514bb9a](https://eu-west-3.console.aws.amazon.com/ec2/home#launchAmi=ami-0078916a37514bb9a) |
| 3.9.3 | sa-east-1 | [ami-09e0025e60328ea6d](https://sa-east-1.console.aws.amazon.com/ec2/home#launchAmi=ami-09e0025e60328ea6d) |
| 3.9.3 | us-east-1 | [ami-05c8c48601c2303af](https://us-east-1.console.aws.amazon.com/ec2/home#launchAmi=ami-05c8c48601c2303af) |
| 3.9.3 | us-east-2 | [ami-064d64386a89de1e6](https://us-east-2.console.aws.amazon.com/ec2/home#launchAmi=ami-064d64386a89de1e6) |
| 3.9.3 | us-west-1 | [ami-04a4711d62db12ba0](https://us-west-1.console.aws.amazon.com/ec2/home#launchAmi=ami-04a4711d62db12ba0) |
| 3.9.3 | us-west-2 | [ami-0ff56870cf29d4f02](https://us-west-2.console.aws.amazon.com/ec2/home#launchAmi=ami-0ff56870cf29d4f02) |

## Caveats

This image is being used in production but it's still somewhat early stage in
its development and thus there are some sharp edges.

- As of 3.9.0-1, this AMI starts `haveged` at the boot runlevel, to provide
  additional initial entropy as discussed in issue #39.  In the long term, we
  hope to find an alternative solution.

- Only EBS-backed HVM instances are supported.  While paravirtualized instances
  are still available from AWS they are not supported on any of the newer
  hardware so it seems unlikely that they will be supported going forward.
  Thus this project does not support them.

- [cloud-init](https://cloudinit.readthedocs.io/en/latest/) is not currently
  supported on Alpine Linux.  Instead this image uses
  [tiny-ec2-bootstrap](https://github.com/mcrute/tiny-ec2-bootstrap).  Hostname
  setting will work, as will setting the ssh keys for the Alpine user based on
  what was configured during instance launch.  User data is supported as long
  as it's a shell script (starts with #!).  See the tiny-ec2-bootstrap README
  for more details.  You can still install cloud-init (from the edge testing
  repositories), but we haven't tested whether it will work correctly for this
  AMI.  If full cloud-init support is important to you please file a bug
  against this project.

- CloudFormation support is still forthcoming.  This requires patches and
  packaging for the upstream cfn tools that have not yet been accepted.
  Eventually full CloudFormation support will be available.
