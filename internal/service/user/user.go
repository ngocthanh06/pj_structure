package service

type UserRepository interface {
}

type userService struct {
	userRepository UserRepository
}

func NewUserService(userRepository UserRepository) *userService {
	return &userService{
		userRepository: userRepository,
	}
}
