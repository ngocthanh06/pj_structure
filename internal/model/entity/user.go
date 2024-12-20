package entity

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type User struct {
	ID              uuid.UUID      `gorm:"type:uuid;primaryKey" json:"id" description:"user id"`
	TelID           uuid.UUID      `gorm:"type:uuid" json:"tel_id" description:"linked tel id"`
	Fullname        string         `gorm:"type:varchar(255);not null" json:"fullname" description:"full name"`
	Nickname        string         `gorm:"type:varchar(255)" json:"nickname" description:"nickname"`
	DOB             string         `gorm:"type:char(10)" json:"dob" description:"date of birth (YYYY-MM-DD)"`
	Email           string         `gorm:"type:varchar(255);unique;not null" json:"email" description:"email"`
	Address         string         `gorm:"type:varchar(255)" json:"address" description:"address"`
	RoleCode        int8           `gorm:"not null" json:"role_code" description:"role code"`
	LanguageID      int            `gorm:"not null" json:"language_id" description:"language id"`
	EmailVerifiedAt *time.Time     `json:"email_verified_at" description:"email verification timestamp"`
	Password        string         `gorm:"type:varchar(255);not null" json:"password" description:"hashed password"`
	RememberToken   string         `gorm:"type:varchar(255)" json:"remember_token" description:"remember token"`
	DeletedAt       gorm.DeletedAt `gorm:"index" json:"deleted_at" description:"soft delete timestamp"`
}

func (u *User) TableName() string {
	return "users"
}

func (m *User) BeforeCreate(tx *gorm.DB) (err error) {
	m.ID = uuid.New()
	return
}
