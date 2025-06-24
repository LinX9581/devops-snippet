pipeline {
  agent { label 'test2' }

  environment {
    IMAGE    = 'node:20-alpine'
    GIT_REPO = 'https://github.com/LinX9581/nodejs-template.git'
    APP_DIR  = "${env.WORKSPACE}"
  }

  stages {
    stage('Checkout') {
      steps {
        git url: GIT_REPO, branch: 'main'
      }
    }

    stage('Install Dependencies') {
      steps {
        sh """
          docker pull ${IMAGE}
          docker run --rm \
            -v ${APP_DIR}:/app \
            -w /app \
            ${IMAGE} \
            sh -c "apk add --no-cache python3 make g++ \\
                   && yarn install"
        """
      }
    }

    stage('Start Application') {
      steps {
        sh """
          docker run --rm \
            -v ${APP_DIR}:/app \
            -w /app \
            -p 3000:3000 \
            ${IMAGE} \
            yarn start
        """
      }
    }
  }

  post {
    always {
      echo "完成於 ${env.NODE_NAME}"
    }
  }
}
