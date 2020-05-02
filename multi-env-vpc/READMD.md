[source code link](https://github.com/thxwelchs/learning-terraform/tree/master/multi-env-vpc)
### 초기화
aws credentials는 aws provider 규칙에 맞게 설정 (환경변수 혹은 ~/.aws/credentials 작성)

각 환경별로 다음 명령 실행
env={dev|staging|prod|data}
```bash
$ git clone https://github.com/thxwelchs/learning-terraform.git
$ cd learning-terraform/multi-env-vpc/{env}
$ terraform init
$ terraform plan
$ terraform apply
```

# VPC 구성

dev,staging,prod로 구성 (HCL에는 data도 있음)

![vpc2](https://user-images.githubusercontent.com/38197077/80860878-b311c480-8ca5-11ea-9927-22c6deee7b8b.png)

*이슈 혹은 느낀점*

- 괜히 환경별로 module을 구성한 것 같다. 한꺼번에 환경별 VPC 구성이 되게하면 더 좋을 것 같다.
- 환경별로 module을 구성하다보니, vpc peering을 HCL로 작성하기 어려웠다. vpc peering 요청을 어떤 vpc에서 어떤 대상vpc로 해야 할지 변수값으로 가져오기가 힘들었다. (다음엔 HCL best practice directory configuration 같은 것을 참고해서 구성해봐야 겠다.)

# 인스턴스 구성

public subnet과 private subnet에 각 한대씩 ec2 배치

- public subnet instance: Vue.js SPA 웹애플리케이션이 nginx (docker)로 배포되어 있음
- private subnet instance: Node.js Rest API가 pm2 (docker)로 배포되어 있음

![data-pipeline](https://user-images.githubusercontent.com/38197077/80860876-b1480100-8ca5-11ea-8fde-a684fbad096b.jpg)


*이슈 혹은 느낀점*

- ALB에서 HTTPS(443) 으로 트래픽이 수신되니까 당연히 타겟그룹도 HTTPS로 설정되어야 되는 줄 알았다. 알고보니 그동안 당연하게도 설정했던건 HTTP로 설정했었는데, 그것도 모르고 있었다. ALB의 SSL은 패스쓰루를 지원하지 않아서 실제로 ALB가 80으로 proxy 해주기 때문에 ALB에서 인스턴스로 통신하기 위해서는 HTTP(80)으로 통신해야 한다는걸 알았다. 아니라면 SSL로만 구성할거라면 EC2 내부에 nginx나 apache에 SSL을 직접 configuration 해야 할 것 같은데 이건 매우 귀찮을 것 같다. (SSL Only 방식이 보안상으로 얼마나 더 유리한지는 나중에 찾아봐야 할 것 같다.)
- EC2 userdata에서 ssm-user에 docker 권한을 주었는데 뭔가 적용이 되지 않는다. ec2-user는 됐음
- EC2 userdata에서 환경변수값을 /etc/profile.d/ 에 쉘스크립트로 작성해서 넣었는데 적용 되지가 않는다. ( source 명령을 하면 그때서야 적용됌, 그래서 그냥 json파일로 만들어서 jq로 query해서 사용했다. profile이 ssh로 로그인시 적용되어야 할 것 같은데 이건 이유를 모르겠다. )
- SSM은 bastion과 다르게 표면상으로는 bash처럼 보이지만, 이것저것 제약이 많은 것 같다. 특히나 실제 OS상 file이나 directory 권한이 그대로 적용되지 않았다.
- 어차피 ALB로 통신하니까 private zone으로만 subnet을 구성해도 괜찮을 것 같다.
- 원래 ECS로 구성하려다가, ECS는 한 클러스터내에서 여러 서비스들을 각 다른 서브넷에 스케줄링 되게 할 순 없는 것 같다. 그래서 EC2로만 구성했다.
- kops나 EKS를 꼭 다음엔 활용 해 봐야겠다. kops를 terraform 으로 구축하려고 했는데 쉽지 않을 것 같다. 그냥 차라리 EKS 쓰는게 나을 것 같다.


# CICD 구성

Github 웹훅 트리거 하여 CodePipeline으로 구성

![cicd-pipeline](https://user-images.githubusercontent.com/38197077/80860891-c2910d80-8ca5-11ea-8692-899f480327cb.png)

*이슈 혹은 느낀점*

- CodeBuild에서 build하는데 되게 오래걸리는 것 같다. 캐시하는 방법을 더 구체적으로 찾아봐야 할 것 같다.
- 원래 하고 싶었던건 dev에서 dev branch로 push 했을 때 dev vpc 환경에 배포가 되게 하고, staging github에 pull request 하게끔 하는거였는데 그렇게 하지 못했다 다음엔 그렇게 해봐야 겠다.
- ECS가 아닌 CodeDeploy로 배포는 처음이라 매우 까다로웠다. 그냥 왠만하면 컨테이너기반의 컴퓨팅은 ECS 혹은 EKS로 하는게 나을 것 같다.
- 쿠버네티스 클러스터의 CD(continuous delivery)는 AWS resource로 아직 제공되지 않는 것 같아서 아쉬웠다. 찾아보니 ArgoCD, JenkinsX, Spinnaker가 현업에선 가장 많이 쓰이는 것 같다.