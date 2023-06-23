pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }

    stages {
        stage('Plan') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                credentialsId: 'terraform-aws',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) { 
                script {
                    currentBuild.displayName = params.version
                }
                sh 'ls'
                sh 'cd terraform/'
                sh 'ls'
                sh 'terraform init -input=false'
                sh "terraform plan -input=false -out tfplan"
                sh 'terraform show -no-color tfplan > tfplan.txt'
                }
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }

            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                        parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                credentialsId: 'terraform-aws',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {                 
                sh "cd terraform"
                sh "terraform apply -input=false tfplan"
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt'
        }
    }
}